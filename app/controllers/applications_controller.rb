class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show edit update destroy download_pdf document ]
  skip_before_action :verify_authenticity_token, only: [:create] # Will remove in production

  # GET /applications or /applications.json
  def index
    @q = Application.order(created_at: :desc).ransack(params[:q])
    authorize @applications = @q.result(distinct: true).page(params[:page]).per(20), policy_class: JobApplicationPolicy

    respond_to do |format|
      format.html
      format.json { render json: @applications }
    end
  end

  # GET /applications/1 or /applications/1.json
  def show
    @application = Application.find(params[:id])
    authorize @application, policy_class: JobApplicationPolicy
  end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
    authorize @application, policy_class: JobApplicationPolicy
  end

  # POST /applications or /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to application_url(@application), notice: "Application was successfully created." }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    authorize @application, policy_class: JobApplicationPolicy
    
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to application_url(@application), notice: "Application was successfully updated." }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /applications/1/download_pdf
  def download_pdf
    authorize @application, policy_class: JobApplicationPolicy

    begin
      generator = ApplicationPdfGenerator.new(@application)
      pdf_content = generator.render

      send_data pdf_content,
                filename: "application_#{@application.id}_#{@application.last_name}.pdf",
                type: "application/pdf",
                disposition: "attachment"
    rescue StandardError => e
      Rails.logger.error "PDF generation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to @application, alert: "Failed to generate PDF: #{e.message}"
    end
  end

  # GET /applications/1/document
  # Serves the PDF inline for embedding in the show page
  def document
    authorize @application, policy_class: JobApplicationPolicy

    begin
      generator = ApplicationPdfGenerator.new(@application)
      pdf_content = generator.render

      send_data pdf_content,
                filename: "application_#{@application.id}.pdf",
                type: "application/pdf",
                disposition: "inline"
    rescue StandardError => e
      Rails.logger.error "PDF generation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      head :internal_server_error
    end
  end

  # DELETE /applications/1 or /applications/1.json
  def destroy
    authorize @application, policy_class: JobApplicationPolicy
    @application.destroy!

    respond_to do |format|
      format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:first_name, :middle_initial, :last_name, :address, :city, :state, :zip, :birthday, :ssn, :phone_number, :email, :residency_address_1, :residency_city_1, :residency_state_1, :residency_zip_1, :residency_address_2, :residency_city_2, :residency_state_2, :residency_zip_2, :residency_address_3, :residency_city_3, :residency_state_3, :residency_zip_3, :license_state, :license_number, :license_type, :license_expiration_date, :conviction_date_1, :conviction_violation_1, :conviction_state_1, :conviction_penalty_1, :conviction_date_2, :conviction_violation_2, :conviction_state_2, :conviction_penalty_2, :conviction_date_3, :conviction_violation_3, :conviction_state_3, :conviction_penalty_3, :experience_class_1, :experience_type_1, :experience_start_date_1, :experience_end_date_1, :experience_miles_1, :experience_class_2, :experience_type_2, :experience_start_date_2, :experience_end_date_2, :experience_miles_2, :experience_class_3, :experience_type_3, :experience_start_date_3, :experience_end_date_3, :experience_miles_3, :accident_date_1, :accident_nature_1, :accident_fatalities_1, :accident_injuries_1, :accident_spill_1, :accident_date_2, :accident_nature_2, :accident_fatalities_2, :accident_injuries_2, :accident_spill_2, :accident_date_3, :accident_nature_3, :accident_fatalities_3, :accident_injuries_3, :accident_spill_3, :contacted)
    end
end
