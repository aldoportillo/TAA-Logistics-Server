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
      params.require(:application).permit(
        # --------------------
        # Personal Info
        # --------------------
        :first_name, :middle_name, :last_name,
        :street, :city, :state, :zip,
        :date_of_birth, :ssn, :phone, :email,

        # --------------------
        # Residences
        # --------------------
        :residence_1_street, :residence_1_city, :residence_1_state, :residence_1_zip, :residence_1_duration,
        :residence_2_street, :residence_2_city, :residence_2_state, :residence_2_zip, :residence_2_duration,
        :residence_3_street, :residence_3_city, :residence_3_state, :residence_3_zip, :residence_3_duration,

        # --------------------
        # License (SINGLE license only — per schema)
        # --------------------
        :license_state, :license_number, :license_type, :license_expiration_date,

        # --------------------
        # Convictions (ONLY 1–3)
        # --------------------
        :conviction_1_date, :conviction_1_violation, :conviction_1_state, :conviction_1_penalty,
        :conviction_2_date, :conviction_2_violation, :conviction_2_state, :conviction_2_penalty,
        :conviction_3_date, :conviction_3_violation, :conviction_3_state, :conviction_3_penalty,

        # --------------------
        # Driving Experience
        # --------------------
        :straight_truck_type, :straight_truck_from, :straight_truck_to, :straight_truck_miles,
        :tractor_semi_type, :tractor_semi_from, :tractor_semi_to, :tractor_semi_miles,
        :tractor_two_trailers_type, :tractor_two_trailers_from, :tractor_two_trailers_to, :tractor_two_trailers_miles,
        :other_type, :other_equipment_from, :other_equipment_to, :other_equipment_miles,

        # --------------------
        # Accidents (ONLY 1–3)
        # --------------------
        :accident_1_date, :accident_1_nature, :accident_1_fatalities, :accident_1_injuries, :accident_1_chemical_spill,
        :accident_2_date, :accident_2_nature, :accident_2_fatalities, :accident_2_injuries, :accident_2_chemical_spill,
        :accident_3_date, :accident_3_nature, :accident_3_fatalities, :accident_3_injuries, :accident_3_chemical_spill,

        # --------------------
        # FMCSA / Compliance
        # --------------------
        :currently_disqualified, :license_suspended, :license_denied,
        :positive_drug_test_last_2_years, :bac_over_point04, :dui,
        :refused_testing, :controlled_substance_violation,
        :drug_transport_possession, :left_scene_of_accident,

        # --------------------
        # Employers (1–3)
        # --------------------
        :employer_1_name, :employer_1_street, :employer_1_city, :employer_1_state, :employer_1_zip,
        :employer_1_phone, :employer_1_position, :employer_1_salary,
        :employer_1_from, :employer_1_to, :employer_1_reason_for_leaving,
        :employer_1_subject_to_fmcsa, :employer_1_safety_sensitive,

        :employer_2_name, :employer_2_street, :employer_2_city, :employer_2_state, :employer_2_zip,
        :employer_2_phone, :employer_2_position, :employer_2_salary,
        :employer_2_from, :employer_2_to, :employer_2_reason_for_leaving,
        :employer_2_subject_to_fmcsa, :employer_2_safety_sensitive,

        :employer_3_name, :employer_3_street, :employer_3_city, :employer_3_state, :employer_3_zip,
        :employer_3_phone, :employer_3_position, :employer_3_salary,
        :employer_3_from, :employer_3_to, :employer_3_reason_for_leaving,
        :employer_3_subject_to_fmcsa, :employer_3_safety_sensitive,

        # --------------------
        # Employment Gaps
        # --------------------
        :gap_1_from, :gap_1_to, :gap_1_reason,
        :gap_2_from, :gap_2_to, :gap_2_reason,

        # --------------------
        # E-Signature
        # --------------------
        :esign_consent, :esign_consent_at, :esign_consent_text,
        :signature_full_name, :signature_method, :signature_timestamp,
        :signing_ip_address, :signing_user_agent,

        # --------------------
        # Template / Submission
        # --------------------
        :template_version, :template_hash, :render_engine_version,
        :submitted_at, :pdf_version

      )
    end
end
