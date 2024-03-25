class InquiriesController < ApplicationController
  before_action :set_inquiry, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create] # Will remove in production

  # GET /inquiries or /inquiries.json
  def index
    authorize @inquiries = Inquiry.all
  end

  # GET /inquiries/1 or /inquiries/1.json
  def show
    authorize @inquiry
  end

  # GET /inquiries/new
  def new
    @inquiry = Inquiry.new
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries or /inquiries.json
  def create
    @inquiry = Inquiry.new(inquiry_params)

    respond_to do |format|
      if @inquiry.save
        format.html { redirect_to inquiry_url(@inquiry), notice: "Inquiry was successfully created." }
        format.json { render :show, status: :created, location: @inquiry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inquiries/1 or /inquiries/1.json
  def update
    respond_to do |format|
      if @inquiry.update(inquiry_params)
        format.html { redirect_to inquiry_url(@inquiry), notice: "Inquiry was successfully updated." }
        format.json { render :show, status: :ok, location: @inquiry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1 or /inquiries/1.json
  def destroy
    authorize @inquiry.destroy!

    respond_to do |format|
      format.html { redirect_to inquiries_url, notice: "Inquiry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inquiry_params
      params.require(:inquiry).permit(:name, :phone_number, :email_address, :message, :contacted)
    end
end
