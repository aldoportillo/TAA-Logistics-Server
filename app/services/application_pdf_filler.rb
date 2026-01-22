require 'prawn'
require 'combine_pdf'

class ApplicationPdfFiller
  TEMPLATE_PATH = Rails.root.join('app', 'assets', 'documents', 'taa-application.pdf')

  def initialize(application)
    @application = application
  end

  def fill_and_generate
    # Create a temporary file for the overlay
    overlay_file = Tempfile.new(['overlay', '.pdf'])
    output_file = Tempfile.new(['filled_application', '.pdf'])

    begin
      # Create overlay PDF with Prawn
      create_overlay_pdf(overlay_file.path)

      # Combine the template and overlay
      template = CombinePDF.load(TEMPLATE_PATH)
      overlay = CombinePDF.load(overlay_file.path)

      # Overlay each page
      template.pages.each_with_index do |page, index|
        if overlay.pages[index]
          page << overlay.pages[index]
        end
      end

      # Save to output file
      template.save(output_file.path)

      # Read and return the filled PDF
      output_file.rewind
      output_file.read
    ensure
      overlay_file.close
      overlay_file.unlink
      output_file.close
      output_file.unlink
    end
  end

  private

  def create_overlay_pdf(file_path)
    Prawn::Document.generate(file_path, page_size: 'LETTER', margin: 0) do |pdf|
      # Page 2: APPLICATION FOR EMPLOYMENT
      pdf.font_size 10

      # Name (full name on one line)
      pdf.draw_text full_name, at: [70, 670], size: 10

      # Address - Street
      pdf.draw_text @application.address.to_s, at: [15, 645], size: 9

      # Address - City
      pdf.draw_text @application.city.to_s, at: [260, 645], size: 9

      # Address - State & Zip
      pdf.draw_text "#{@application.state} #{@application.zip}", at: [415, 645], size: 9

      # Date of Birth
      pdf.draw_text format_date(@application.birthday), at: [100, 620], size: 9

      # Social Security Number
      pdf.draw_text @application.ssn.to_s, at: [340, 620], size: 9

      # Phone Number
      pdf.draw_text @application.phone_number.to_s, at: [130, 575], size: 9

      # Email Address
      pdf.draw_text @application.email.to_s, at: [320, 575], size: 9

      # PREVIOUS THREE YEARS RESIDENCY
      # Residency 1
      if @application.residency_address_1.present?
        residency_1 = "#{@application.residency_address_1}, #{@application.residency_city_1}, #{@application.residency_state_1} #{@application.residency_zip_1}"
        pdf.draw_text residency_1, at: [15, 510], size: 8
      end

      # Residency 2
      if @application.residency_address_2.present?
        residency_2 = "#{@application.residency_address_2}, #{@application.residency_city_2}, #{@application.residency_state_2} #{@application.residency_zip_2}"
        pdf.draw_text residency_2, at: [15, 485], size: 8
      end

      # Residency 3
      if @application.residency_address_3.present?
        residency_3 = "#{@application.residency_address_3}, #{@application.residency_city_3}, #{@application.residency_state_3} #{@application.residency_zip_3}"
        pdf.draw_text residency_3, at: [15, 460], size: 8
      end

      # Page 3: LICENSE INFORMATION
      pdf.start_new_page

      # License State
      pdf.draw_text @application.license_state.to_s, at: [15, 580], size: 9

      # License Number
      pdf.draw_text @application.license_number.to_s, at: [135, 580], size: 9

      # License Type
      pdf.draw_text @application.license_type.to_s, at: [280, 580], size: 9

      # License Expiration Date
      pdf.draw_text format_date(@application.license_expiration_date), at: [420, 580], size: 9

      # TRAFFIC CONVICTIONS
      # Conviction 1
      if @application.conviction_date_1.present?
        pdf.draw_text format_date(@application.conviction_date_1), at: [15, 455], size: 8
        pdf.draw_text @application.conviction_violation_1.to_s, at: [115, 455], size: 8
        pdf.draw_text @application.conviction_state_1.to_s, at: [280, 455], size: 8
        pdf.draw_text @application.conviction_penalty_1.to_s, at: [420, 455], size: 8
      end

      # Conviction 2
      if @application.conviction_date_2.present?
        pdf.draw_text format_date(@application.conviction_date_2), at: [15, 430], size: 8
        pdf.draw_text @application.conviction_violation_2.to_s, at: [115, 430], size: 8
        pdf.draw_text @application.conviction_state_2.to_s, at: [280, 430], size: 8
        pdf.draw_text @application.conviction_penalty_2.to_s, at: [420, 430], size: 8
      end

      # Conviction 3
      if @application.conviction_date_3.present?
        pdf.draw_text format_date(@application.conviction_date_3), at: [15, 405], size: 8
        pdf.draw_text @application.conviction_violation_3.to_s, at: [115, 405], size: 8
        pdf.draw_text @application.conviction_state_3.to_s, at: [280, 405], size: 8
        pdf.draw_text @application.conviction_penalty_3.to_s, at: [420, 405], size: 8
      end

      # DRIVING EXPERIENCE
      # Experience 1
      if @application.experience_class_1.present?
        pdf.draw_text @application.experience_class_1.to_s, at: [15, 285], size: 8
        pdf.draw_text @application.experience_type_1.to_s, at: [135, 285], size: 8
        pdf.draw_text format_date(@application.experience_start_date_1), at: [260, 285], size: 8
        pdf.draw_text format_date(@application.experience_end_date_1), at: [315, 285], size: 8
        pdf.draw_text @application.experience_miles_1.to_s, at: [420, 285], size: 8
      end

      # Experience 2
      if @application.experience_class_2.present?
        pdf.draw_text @application.experience_class_2.to_s, at: [15, 260], size: 8
        pdf.draw_text @application.experience_type_2.to_s, at: [135, 260], size: 8
        pdf.draw_text format_date(@application.experience_start_date_2), at: [260, 260], size: 8
        pdf.draw_text format_date(@application.experience_end_date_2), at: [315, 260], size: 8
        pdf.draw_text @application.experience_miles_2.to_s, at: [420, 260], size: 8
      end

      # Experience 3
      if @application.experience_class_3.present?
        pdf.draw_text @application.experience_class_3.to_s, at: [15, 235], size: 8
        pdf.draw_text @application.experience_type_3.to_s, at: [135, 235], size: 8
        pdf.draw_text format_date(@application.experience_start_date_3), at: [260, 235], size: 8
        pdf.draw_text format_date(@application.experience_end_date_3), at: [315, 235], size: 8
        pdf.draw_text @application.experience_miles_3.to_s, at: [420, 235], size: 8
      end

      # Page 4: ACCIDENT RECORD
      pdf.start_new_page

      # Accident 1
      if @application.accident_date_1.present?
        pdf.draw_text format_date(@application.accident_date_1), at: [15, 605], size: 8
        pdf.draw_text @application.accident_nature_1.to_s, at: [80, 605], size: 8
        pdf.draw_text @application.accident_fatalities_1.to_s, at: [245, 605], size: 8
        pdf.draw_text @application.accident_injuries_1.to_s, at: [335, 605], size: 8
        pdf.draw_text format_boolean(@application.accident_spill_1), at: [440, 605], size: 8
      end

      # Accident 2
      if @application.accident_date_2.present?
        pdf.draw_text format_date(@application.accident_date_2), at: [15, 580], size: 8
        pdf.draw_text @application.accident_nature_2.to_s, at: [80, 580], size: 8
        pdf.draw_text @application.accident_fatalities_2.to_s, at: [245, 580], size: 8
        pdf.draw_text @application.accident_injuries_2.to_s, at: [335, 580], size: 8
        pdf.draw_text format_boolean(@application.accident_spill_2), at: [440, 580], size: 8
      end

      # Accident 3
      if @application.accident_date_3.present?
        pdf.draw_text format_date(@application.accident_date_3), at: [15, 555], size: 8
        pdf.draw_text @application.accident_nature_3.to_s, at: [80, 555], size: 8
        pdf.draw_text @application.accident_fatalities_3.to_s, at: [245, 555], size: 8
        pdf.draw_text @application.accident_injuries_3.to_s, at: [335, 555], size: 8
        pdf.draw_text format_boolean(@application.accident_spill_3), at: [440, 555], size: 8
      end

      # Continue with remaining pages as needed...
      # Pages 5-8 contain employment history and signatures which would need similar treatment
    end
  end

  def full_name
    [@application.first_name, @application.middle_initial, @application.last_name].compact.join(' ')
  end

  def format_date(date)
    date&.strftime('%m/%d/%Y') || ''
  end

  def format_boolean(value)
    return '' if value.nil?
    value ? 'Yes' : 'No'
  end
end
