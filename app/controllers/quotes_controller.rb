class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create] # Will remove in production

  # GET /quotes
  def index
    authorize Quote
    @q = Quote.ransack(params[:q])
    base_quotes = policy_scope(Quote).merge(@q.result(distinct: true))
    
    @employee_quotes = base_quotes.where(created_by_employee: true).order(created_at: :desc)
    @customer_quotes = base_quotes.where(created_by_employee: false).order(created_at: :desc)

    respond_to do |format|
      format.html
      format.json { render json: { employee_quotes: @employee_quotes, customer_quotes: @customer_quotes } }
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
    authorize @quote
    @ports = Port.where(active: true).order(:name)
  end

  # GET /quotes/1/edit
  def edit
    authorize @quote
    @ports = Port.where(active: true).order(:name)
  end

  # POST /quotes or /quotes.json
  def create
    @quote = Quote.new(quote_params)
    authorize @quote

    if quote_params[:destination].present? && quote_params[:from].present?
      total = quote_total(quote_params[:from], quote_params[:destination], quote_params[:rate_per_mile].to_f, quote_params[:fsch_percent].to_f)

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
    authorize @quote
    # Check if we need to recalculate totals
    if quote_params[:destination].present? && quote_params[:from].present? && 
       (quote_params[:from] != @quote.from || 
        quote_params[:destination] != @quote.destination || 
        quote_params[:rate_per_mile].to_f != @quote.rate_per_mile.to_f || 
        quote_params[:fsch_percent].to_f != @quote.fsch_percent.to_f)
      
      total = quote_total(quote_params[:from], quote_params[:destination], quote_params[:rate_per_mile].to_f, quote_params[:fsch_percent].to_f)
      
      # Update the quote params with calculated values
      updated_params = quote_params.merge(
        miles: total[:miles],
        line_haul: total[:line_haul],
        fuel_surcharge: total[:fuel_surcharge],
        total: total[:total]
      )
      
      update_result = @quote.update(updated_params)
    else
      update_result = @quote.update(quote_params)
    end

    respond_to do |format|
      if update_result
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
    authorize @quote
    @quote.destroy!

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

    def quote_total(from_address, destination, rate, fsch_percent)
      google_maps = GoogleMapsService.new

      trip_stops = [
        from_address,
        destination,
        from_address
      ]

      miles = google_maps.fetch_distance(trip_stops)[:distance].to_f
      line_haul = helpers.calculate_line_haul(miles, rate)
      fuel_surcharge = (fsch_percent / 100) * line_haul
      total = line_haul + fuel_surcharge

      return { miles: miles, line_haul: line_haul, fuel_surcharge: fuel_surcharge, total: total }

    end
end
