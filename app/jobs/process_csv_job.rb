require 'smarter_csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_path)
    google_maps = GoogleMapsService.new
    results = []

    # SmarterCSV options to skip the first two rows and clean data
    options = {
      headers_in_file: true,  # Detects headers automatically
      skip_lines: 2,          # Skips the first two rows
      remove_empty_values: true,
      strip_whitespace: true,
      convert_values_to_numeric: false # Keeps values as strings
    }

    # Read CSV using SmarterCSV
    csv_data = SmarterCSV.process(csv_path, options)

    # Normalize headers: replace `/` with `_`
    csv_data.map! do |row|
      row.transform_keys! { |key| key.to_s.downcase.gsub("/", "_").to_sym }
    end

    # Debugging: Check actual column names after normalization
    actual_columns = csv_data.first.keys
    puts "Actual Columns: #{actual_columns.inspect}"

    required_columns = [:ramp_port_location, :consignee_shipper_city, :consignee_shipper_state]

    # Ensure required columns exist
    missing_columns = required_columns - actual_columns
    if missing_columns.any?
      raise "Missing expected columns: #{missing_columns.join(', ')}"
    end

    csv_data.each do |row|
      destination = "#{row[:ramp_port_location]}, #{row[:consignee_shipper_city]}, #{row[:consignee_shipper_state]}"

      # Debugging: Check destination formatting
      puts "Processing destination: #{destination.inspect}"

      next if destination.strip == ", , " || destination.nil? # Skip blank rows

      distance, tolls = google_maps.fetch_distance_and_tolls(destination)

      results << row.merge({
        distance_miles: distance || "Error",
        number_of_tolls: tolls || "Error"
      })
    end

    # Save new CSV with additional columns
    new_csv_path = Rails.root.join('tmp', "processed_bids.csv")
    headers = results.first.keys.map(&:to_s).map(&:humanize)

    CSV.open(new_csv_path, 'w', write_headers: true, headers: headers) do |csv|
      results.each { |row| csv << row.values }
    end

    new_csv_path
  end
end
