class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create] # Will remove in production

  # GET /quotes or /quotes.json
  def index

    @q = Quote.order(created_at: :desc).ransack(params[:q])
  
    authorize @quotes = @q.result(distinct: true).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.json { render json: @quotes }
    end
  end

  # GET /quotes/1 or /quotes/1.json
  def show
    @quote = Quote.find(params[:id])
    authorize @quote

    respond_to do |format|
      format.html
      format.json { render :show, status: :ok, location: @quote }
    end
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes or /quotes.json
  def create
    @quote = Quote.new(quote_params)

    if quote_params[:destination].present?
      total = quote_total(quote_params[:destination], quote_params[:rate_per_mile].to_f, quote_params[:fsch_percent].to_f)

      @quote.miles = total[:miles]
      @quote.line_haul = total[:line_haul]
      @quote.fuel_surcharge = total[:fuel_surcharge]
      @quote.total = total[:total]
    end

    respond_to do |format|
      if @quote.save
        format.html { redirect_to quote_url(@quote), notice: "Quote was successfully created." }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to quote_url(@quote), notice: "Quote was successfully updated." }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    
    authorize @quote.destroy!

    respond_to do |format|
      format.html { redirect_to quotes_url, notice: "Quote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(:company_name, :contact_name, :email, :phone, :fax, :commodity, :commodity_temp, :commodity_gross_weight, :from, :delivery_date, :delivery_zip_code, :shipping_date, :shipping_zip_code, :CS, :container_size, :pallets, :equipment_type, :rail_destination, :questions_or_notes, :contacted, :destination, :rate_per_mile, :fsch_percent, :miles, :line_haul, :fuel_surcharge, :total, :created_by_employee)
    end

    def quote_total(destination, rate, fsch_percent)
      google_maps = GoogleMapsService.new

      trip_stops = [
        "18949 Wolf Rd, Mokena, IL 60448",
        destination,
        "18949 Wolf Rd, Mokena, IL 60448"
      ]

      miles = google_maps.fetch_distance(trip_stops)[:distance].to_f
      line_haul = helpers.calculate_line_haul(miles, rate)
      fuel_surcharge = (fsch_percent / 100) * line_haul
      total = line_haul + fuel_surcharge

      return { miles: miles, line_haul: line_haul, fuel_surcharge: fuel_surcharge, total: total }

    end
end
