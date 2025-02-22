require 'csv'
require 'smarter_csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default
  include BidsHelper

  def perform(csv_path, params)
    google_maps = GoogleMapsService.new
    results = []

    options = {
      headers_in_file: true,
      skip_lines: 2,
      remove_empty_values: true,
      strip_whitespace: true
    }

    csv_data = SmarterCSV.process(csv_path, options)

    csv_data.map! do |row|
      row.transform_keys! { |key| key.to_s.downcase.gsub("/", "_").to_sym }
    end

    required_columns = [:ramp_port_location, :consignee_shipper_city, :consignee_shipper_state]
    actual_columns = csv_data.first.keys

    missing_columns = required_columns - actual_columns
    if missing_columns.any?
      raise "Missing expected columns: #{missing_columns.join(', ')}"
    end

    csv_data.each_with_index do |row, i|
      ramp_address = google_maps.get_ramp_address(row[:ramp_port_location])

      consignee_location = google_maps.validate_location(row[:consignee_shipper_city], row[:consignee_shipper_state])

      trip_stops = [
        "18949 Wolf Rd, Mokena, IL 60448",
        ramp_address,
        consignee_location,
        "18949 Wolf Rd, Mokena, IL 60448"
      ]

      pp "Processing trip #{i}: #{trip_stops.inspect}"

      distance_result = google_maps.fetch_distance(trip_stops)

      results << {
        "Ramp/Port Location" => row[:ramp_port_location],
        "Consignee/Shipper City" => row[:consignee_shipper_city],
        "Consignee/Shipper State" => row[:consignee_shipper_state],
        "LH + FSCH" => calculate_linehaul_plus_fuelsurcharge(distance_result[:distance], params[:rate_per_mile], params[:fuel_surcharge]),
        "Distance (mi)" => distance_result[:distance]
      }
    end

    new_csv_path = Rails.root.join('tmp', "#{Time.now}_processed_bids.csv")
    headers = results.first.keys

    CSV.open(new_csv_path, 'w', write_headers: true, headers: headers) do |csv|
      results.each { |row| csv << row.values }
    end

    new_csv_path
  end
end
