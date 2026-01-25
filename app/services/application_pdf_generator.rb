# frozen_string_literal: true

require "hexapdf"

# Generates a filled PDF by populating form fields in the template.
#
# Usage:
#   generator = ApplicationPdfGenerator.new(application)
#   generator.render          # => PDF string
#   generator.save_to(path)   # => saves to file
#   generator.field_names     # => list all form field names in template (for debugging)
#
# Prerequisites:
#   The PDF template must have named form fields that match the field mappings below.
#   Use Adobe Acrobat, LibreOffice Draw, or similar to add form fields to the template.
#
class ApplicationPdfGenerator
  class TemplateError < StandardError; end

  attr_reader :application, :template

  def initialize(application, template_version: nil)
    @application = application
    @template = ApplicationTemplate.new(template_version)
    @template.verify!
  end

  def render
    doc = HexaPDF::Document.open(template.path.to_s)
    fill_form(doc)
    flatten_form(doc)

    io = StringIO.new
    doc.write(io)
    io.string
  end

  def save_to(path)
    File.binwrite(path, render)
  end

  # Returns all form field names in the template (useful for debugging/mapping)
  def field_names
    doc = HexaPDF::Document.open(template.path.to_s)
    doc.acro_form&.each_field&.map(&:full_field_name) || []
  end

  # Returns a hash showing which fields exist vs which we're trying to fill
  def field_mapping_report
    existing = field_names
    mapped = field_mappings.keys.map(&:to_s)

    {
      template_fields: existing,
      mapped_fields: mapped,
      missing_in_template: mapped - existing,
      unmapped_in_template: existing - mapped
    }
  end

  private

  def fill_form(doc)
    form = doc.acro_form
    return unless form

    field_mappings.each do |field_name, value|
      field = form.field_by_name(field_name.to_s)
      next unless field

      set_field_value(field, value)
    end
  end

  def set_field_value(field, value)
    return if value.nil?

    case field.field_type
    when :Btn # Checkbox or radio button
      field.field_value = value ? "Yes" : "Off"
    when :Tx  # Text field
      field.field_value = value.to_s
    when :Ch  # Choice (dropdown/list)
      field.field_value = value.to_s
    else
      field.field_value = value.to_s
    end
  rescue StandardError => e
    Rails.logger.warn("Failed to set PDF field '#{field.full_field_name}': #{e.message}")
  end

  def flatten_form(doc)
    doc.acro_form&.flatten
  rescue StandardError => e
    Rails.logger.warn("Failed to flatten PDF form: #{e.message}")
  end

  # ===========================================
  # Field Mappings
  # ===========================================
  # Maps PDF form field names to application values.
  # Field names must match exactly what's in the PDF template.
  #
  # To see available fields in your template, run:
  #   ApplicationPdfGenerator.new(application).field_names
  #
  def field_mappings
    {
      # Personal Info
      "first_name" => application.first_name,
      "middle_name" => application.middle_name,
      "last_name" => application.last_name,
      "full_name" => full_name,
      "street" => application.street,
      "city" => application.city,
      "state" => application.state,
      "zip" => application.zip,
      "address_line" => address_line,
      "date_of_birth" => format_date(application.date_of_birth),
      "ssn" => application.ssn,
      "phone" => application.phone,
      "email" => application.email,

      # Residence 1
      "residence_1_street" => application.residence_1_street,
      "residence_1_city" => application.residence_1_city,
      "residence_1_state" => application.residence_1_state,
      "residence_1_zip" => application.residence_1_zip,
      "residence_1_duration" => application.residence_1_duration,
      "residence_1_full" => residence_line(1),

      # Residence 2
      "residence_2_street" => application.residence_2_street,
      "residence_2_city" => application.residence_2_city,
      "residence_2_state" => application.residence_2_state,
      "residence_2_zip" => application.residence_2_zip,
      "residence_2_duration" => application.residence_2_duration,
      "residence_2_full" => residence_line(2),

      # Residence 3
      "residence_3_street" => application.residence_3_street,
      "residence_3_city" => application.residence_3_city,
      "residence_3_state" => application.residence_3_state,
      "residence_3_zip" => application.residence_3_zip,
      "residence_3_duration" => application.residence_3_duration,
      "residence_3_full" => residence_line(3),

      # License 1
      "license_1_state" => application.license_1_state,
      "license_1_number" => application.license_1_number,
      "license_1_type" => application.license_1_type,
      "license_1_expiration" => format_date(application.license_1_expiration),

      # License 2
      "license_2_state" => application.license_2_state,
      "license_2_number" => application.license_2_number,
      "license_2_type" => application.license_2_type,
      "license_2_expiration" => format_date(application.license_2_expiration),

      # License 3
      "license_3_state" => application.license_3_state,
      "license_3_number" => application.license_3_number,
      "license_3_type" => application.license_3_type,
      "license_3_expiration" => format_date(application.license_3_expiration),

      # Convictions
      "conviction_1_date" => format_date(application.conviction_1_date),
      "conviction_1_violation" => application.conviction_1_violation,
      "conviction_1_state" => application.conviction_1_state,
      "conviction_1_penalty" => application.conviction_1_penalty,

      "conviction_2_date" => format_date(application.conviction_2_date),
      "conviction_2_violation" => application.conviction_2_violation,
      "conviction_2_state" => application.conviction_2_state,
      "conviction_2_penalty" => application.conviction_2_penalty,

      "conviction_3_date" => format_date(application.conviction_3_date),
      "conviction_3_violation" => application.conviction_3_violation,
      "conviction_3_state" => application.conviction_3_state,
      "conviction_3_penalty" => application.conviction_3_penalty,

      "conviction_4_date" => format_date(application.conviction_4_date),
      "conviction_4_violation" => application.conviction_4_violation,
      "conviction_4_state" => application.conviction_4_state,
      "conviction_4_penalty" => application.conviction_4_penalty,

      "conviction_5_date" => format_date(application.conviction_5_date),
      "conviction_5_violation" => application.conviction_5_violation,
      "conviction_5_state" => application.conviction_5_state,
      "conviction_5_penalty" => application.conviction_5_penalty,

      # Driving Experience
      "straight_truck_from" => format_date(application.straight_truck_from),
      "straight_truck_to" => format_date(application.straight_truck_to),
      "straight_truck_miles" => format_number(application.straight_truck_miles),

      "tractor_semi_from" => format_date(application.tractor_semi_from),
      "tractor_semi_to" => format_date(application.tractor_semi_to),
      "tractor_semi_miles" => format_number(application.tractor_semi_miles),

      "tractor_two_trailers_from" => format_date(application.tractor_two_trailers_from),
      "tractor_two_trailers_to" => format_date(application.tractor_two_trailers_to),
      "tractor_two_trailers_miles" => format_number(application.tractor_two_trailers_miles),

      "other_equipment_description" => application.other_equipment_description,
      "other_equipment_from" => format_date(application.other_equipment_from),
      "other_equipment_to" => format_date(application.other_equipment_to),
      "other_equipment_miles" => format_number(application.other_equipment_miles),

      # Accidents
      "accident_1_date" => format_date(application.accident_1_date),
      "accident_1_nature" => application.accident_1_nature,
      "accident_1_fatalities" => application.accident_1_fatalities&.to_s,
      "accident_1_injuries" => application.accident_1_injuries&.to_s,
      "accident_1_chemical_spill" => yes_no(application.accident_1_chemical_spill),

      "accident_2_date" => format_date(application.accident_2_date),
      "accident_2_nature" => application.accident_2_nature,
      "accident_2_fatalities" => application.accident_2_fatalities&.to_s,
      "accident_2_injuries" => application.accident_2_injuries&.to_s,
      "accident_2_chemical_spill" => yes_no(application.accident_2_chemical_spill),

      "accident_3_date" => format_date(application.accident_3_date),
      "accident_3_nature" => application.accident_3_nature,
      "accident_3_fatalities" => application.accident_3_fatalities&.to_s,
      "accident_3_injuries" => application.accident_3_injuries&.to_s,
      "accident_3_chemical_spill" => yes_no(application.accident_3_chemical_spill),

      # FMCSR Questions (checkboxes)
      "currently_disqualified" => application.currently_disqualified,
      "currently_disqualified_yes" => application.currently_disqualified == true,
      "currently_disqualified_no" => application.currently_disqualified == false,

      "license_suspended" => application.license_suspended,
      "license_suspended_yes" => application.license_suspended == true,
      "license_suspended_no" => application.license_suspended == false,

      "license_denied" => application.license_denied,
      "license_denied_yes" => application.license_denied == true,
      "license_denied_no" => application.license_denied == false,

      "positive_drug_test_last_2_years" => application.positive_drug_test_last_2_years,
      "positive_drug_test_yes" => application.positive_drug_test_last_2_years == true,
      "positive_drug_test_no" => application.positive_drug_test_last_2_years == false,

      "bac_over_point04" => application.bac_over_point04,
      "bac_over_point04_yes" => application.bac_over_point04 == true,
      "bac_over_point04_no" => application.bac_over_point04 == false,

      "dui" => application.dui,
      "dui_yes" => application.dui == true,
      "dui_no" => application.dui == false,

      "refused_testing" => application.refused_testing,
      "refused_testing_yes" => application.refused_testing == true,
      "refused_testing_no" => application.refused_testing == false,

      "controlled_substance_violation" => application.controlled_substance_violation,
      "controlled_substance_yes" => application.controlled_substance_violation == true,
      "controlled_substance_no" => application.controlled_substance_violation == false,

      "drug_transport_possession" => application.drug_transport_possession,
      "drug_transport_yes" => application.drug_transport_possession == true,
      "drug_transport_no" => application.drug_transport_possession == false,

      "left_scene_of_accident" => application.left_scene_of_accident,
      "left_scene_yes" => application.left_scene_of_accident == true,
      "left_scene_no" => application.left_scene_of_accident == false,

      # Employer 1
      "employer_1_name" => application.employer_1_name,
      "employer_1_street" => application.employer_1_street,
      "employer_1_city" => application.employer_1_city,
      "employer_1_state" => application.employer_1_state,
      "employer_1_zip" => application.employer_1_zip,
      "employer_1_address" => employer_address(1),
      "employer_1_phone" => application.employer_1_phone,
      "employer_1_position" => application.employer_1_position,
      "employer_1_salary" => application.employer_1_salary,
      "employer_1_from" => format_date(application.employer_1_from),
      "employer_1_to" => format_date(application.employer_1_to),
      "employer_1_reason_for_leaving" => application.employer_1_reason_for_leaving,
      "employer_1_subject_to_fmcsa" => application.employer_1_subject_to_fmcsa,
      "employer_1_fmcsa_yes" => application.employer_1_subject_to_fmcsa == true,
      "employer_1_fmcsa_no" => application.employer_1_subject_to_fmcsa == false,
      "employer_1_safety_sensitive" => application.employer_1_safety_sensitive,
      "employer_1_safety_yes" => application.employer_1_safety_sensitive == true,
      "employer_1_safety_no" => application.employer_1_safety_sensitive == false,

      # Employer 2
      "employer_2_name" => application.employer_2_name,
      "employer_2_street" => application.employer_2_street,
      "employer_2_city" => application.employer_2_city,
      "employer_2_state" => application.employer_2_state,
      "employer_2_zip" => application.employer_2_zip,
      "employer_2_address" => employer_address(2),
      "employer_2_phone" => application.employer_2_phone,
      "employer_2_position" => application.employer_2_position,
      "employer_2_salary" => application.employer_2_salary,
      "employer_2_from" => format_date(application.employer_2_from),
      "employer_2_to" => format_date(application.employer_2_to),
      "employer_2_reason_for_leaving" => application.employer_2_reason_for_leaving,
      "employer_2_subject_to_fmcsa" => application.employer_2_subject_to_fmcsa,
      "employer_2_fmcsa_yes" => application.employer_2_subject_to_fmcsa == true,
      "employer_2_fmcsa_no" => application.employer_2_subject_to_fmcsa == false,
      "employer_2_safety_sensitive" => application.employer_2_safety_sensitive,
      "employer_2_safety_yes" => application.employer_2_safety_sensitive == true,
      "employer_2_safety_no" => application.employer_2_safety_sensitive == false,

      # Employer 3
      "employer_3_name" => application.employer_3_name,
      "employer_3_street" => application.employer_3_street,
      "employer_3_city" => application.employer_3_city,
      "employer_3_state" => application.employer_3_state,
      "employer_3_zip" => application.employer_3_zip,
      "employer_3_address" => employer_address(3),
      "employer_3_phone" => application.employer_3_phone,
      "employer_3_position" => application.employer_3_position,
      "employer_3_salary" => application.employer_3_salary,
      "employer_3_from" => format_date(application.employer_3_from),
      "employer_3_to" => format_date(application.employer_3_to),
      "employer_3_reason_for_leaving" => application.employer_3_reason_for_leaving,
      "employer_3_subject_to_fmcsa" => application.employer_3_subject_to_fmcsa,
      "employer_3_fmcsa_yes" => application.employer_3_subject_to_fmcsa == true,
      "employer_3_fmcsa_no" => application.employer_3_subject_to_fmcsa == false,
      "employer_3_safety_sensitive" => application.employer_3_safety_sensitive,
      "employer_3_safety_yes" => application.employer_3_safety_sensitive == true,
      "employer_3_safety_no" => application.employer_3_safety_sensitive == false,

      # Employment Gaps
      "gap_1_from" => format_date(application.gap_1_from),
      "gap_1_to" => format_date(application.gap_1_to),
      "gap_1_reason" => application.gap_1_reason,
      "gap_1_full" => gap_explanation(1),

      "gap_2_from" => format_date(application.gap_2_from),
      "gap_2_to" => format_date(application.gap_2_to),
      "gap_2_reason" => application.gap_2_reason,
      "gap_2_full" => gap_explanation(2),

      # Signature Fields
      "signature_full_name" => application.signature_full_name,
      "signature_date" => format_date(application.signature_timestamp),
      "applicant_signature" => application.signature_full_name,
      "applicant_signature_date" => format_date(application.signature_timestamp),

      # Page 8 - Safety Performance History
      "sph_full_name" => full_name,
      "sph_ssn" => application.ssn,
      "sph_dob" => format_date(application.date_of_birth),
      "sph_date_of_application" => format_date(application.submitted_at || application.created_at),
      "sph_applicant_signature" => application.signature_full_name,
      "sph_signature_date" => format_date(application.signature_timestamp),

      # Previous employer for SPH (using employer_1)
      "sph_previous_employer" => application.employer_1_name,
      "sph_previous_employer_phone" => application.employer_1_phone,
      "sph_previous_employer_street" => application.employer_1_street,
      "sph_previous_employer_city_state_zip" => employer_city_state_zip(1)
    }
  end

  # ===========================================
  # Helper Methods
  # ===========================================

  def full_name
    [application.first_name, application.middle_name, application.last_name]
      .compact_blank.join(" ")
  end

  def address_line
    [application.street, application.city, "#{application.state} #{application.zip}"]
      .compact_blank.join(", ")
  end

  def residence_line(n)
    street = application.send("residence_#{n}_street")
    city = application.send("residence_#{n}_city")
    state = application.send("residence_#{n}_state")
    zip = application.send("residence_#{n}_zip")

    [street, city, "#{state} #{zip}"].compact_blank.join(", ")
  end

  def employer_address(n)
    [
      application.send("employer_#{n}_street"),
      application.send("employer_#{n}_city"),
      application.send("employer_#{n}_state"),
      application.send("employer_#{n}_zip")
    ].compact_blank.join(", ")
  end

  def employer_city_state_zip(n)
    [
      application.send("employer_#{n}_city"),
      application.send("employer_#{n}_state"),
      application.send("employer_#{n}_zip")
    ].compact_blank.join(", ")
  end

  def gap_explanation(n)
    from = application.send("gap_#{n}_from")
    to = application.send("gap_#{n}_to")
    reason = application.send("gap_#{n}_reason")

    return nil if from.blank? && reason.blank?

    parts = []
    parts << "#{format_date(from)} - #{format_date(to)}" if from.present?
    parts << reason if reason.present?
    parts.join(": ")
  end

  def format_date(date)
    return nil if date.blank?

    date.to_date.strftime("%m/%d/%Y")
  rescue StandardError
    date.to_s
  end

  def format_number(num)
    return nil if num.blank?

    num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def yes_no(value)
    return nil if value.nil?

    value ? "Yes" : "No"
  end
end
