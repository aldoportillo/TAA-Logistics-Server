require 'csv'
require 'smarter_csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default
  include BidsHelper

  def perform(csv_path, params)
    google_maps = GoogleMapsService.new
    results = []

    # Try user-specified columns first
    if has_user_specified_columns?(params)
      Rails.logger.info "Using user-specified column mapping"
      result = parse_csv_with_user_columns(csv_path, params)
      
      if result[:data].empty?
        raise "No valid rows could be processed from the CSV file using your specified columns."
      end
      
      # Convert the parsed data to the format expected by the rest of the method
      csv_data = result[:data].map do |row_data|
        {
          origin: row_data[:origin],
          destination: row_data[:destination]
        }
      end
      
      # Create a simple column mapping for the new format
      column_mapping = {
        origin: :origin,
        destination: :destination
      }
      
    else
      Rails.logger.info "No user columns specified, using smart detection"
      
      # Find the actual header row and parse CSV
      csv_data = parse_csv_with_dynamic_headers(csv_path, params)
      
      if csv_data.nil? || csv_data.empty?
        pp "ERROR: Could not parse CSV file with any configuration"
        raise "Could not parse CSV file. Please check the file format and ensure it has proper headers."
      end

      # Debug: Show all available columns
      actual_columns = csv_data.first.keys
      pp "=== CSV COLUMN MAPPING DEBUG ==="
      pp "Available columns in CSV: #{actual_columns}"

      # Store sample data for error messages
      @sample_data_for_description = csv_data.first if csv_data.any?

      # Use smart mapping
      column_mapping = build_column_mapping(actual_columns, params)
      pp "Column mapping result: #{column_mapping}"

      # Validate we have the required mappings
      validate_required_columns(column_mapping, actual_columns)
    end

    # Process each row
    csv_data.each_with_index do |row, i|
      begin
        pp "Processing row #{i + 1}..."
        
        # Extract origin and destination using our mapping
        if has_user_specified_columns?(params)
          # For user-specified columns, the data is already in the right format
          origin_info = { location: row[:origin], display: row[:origin] }
          destination_info = { location: row[:destination], display: row[:destination], city: nil, state: nil }
        else
          # For smart detection, use the existing extraction methods
          origin_info = extract_origin(row, column_mapping)
          destination_info = extract_destination(row, column_mapping)
        end
        
        pp "Row #{i + 1} values: origin='#{origin_info}', destination='#{destination_info}'"
        
        # Skip empty rows
        if origin_info[:location].blank? && destination_info[:location].blank?
          pp "Skipping empty row #{i + 1}"
          next
        end

        # Get ramp address
        ramp_address = google_maps.get_ramp_address(origin_info[:location])
        
        # Build consignee location
        consignee_location = if destination_info[:state].present?
          google_maps.validate_location(destination_info[:city], destination_info[:state])
        else
          google_maps.validate_location(destination_info[:location], nil)
        end
        
        pp "Final locations: origin='#{ramp_address}', destination='#{consignee_location}'"

        # Build trip stops
        if params[:use_accurate_miles] == "true"
          trip_stops = [
            "18949 Wolf Rd, Mokena, IL 60448",
            ramp_address,
            consignee_location,
            "18949 Wolf Rd, Mokena, IL 60448"
          ]
          route_type = "accurate"
        else
          trip_stops = [
            ramp_address,
            consignee_location,
            ramp_address
          ]
          route_type = "simple"
        end

        # Calculate distance
        distance_result = google_maps.fetch_distance(trip_stops)
        google_round_trip_miles = distance_result[:distance].to_f

        # Build result row
        result_row = {
          "Ramp/Port Location" => origin_info[:location],
          "Destination City" => "#{destination_info[:display]} (#{google_round_trip_miles.round(0)} miles #{route_type})",
          "Consignee/Shipper State" => destination_info[:state],
          "LH + FSCH" => calculate_line_haul_including_fuel(google_round_trip_miles, params[:rate_per_mile]).round(2),
          "LH only" => (calculate_line_haul_including_fuel(google_round_trip_miles, params[:rate_per_mile]) / 1.295).round(2),
          "Distance (mi)" => google_round_trip_miles.round(2)
        }

        # Add optional fields if they exist in the mapping
        add_optional_fields(result_row, row, column_mapping)

        results << result_row
        pp "Successfully processed row #{i + 1}"
        
      rescue StandardError => e
        pp "Error processing row #{i + 1}: #{e.message}"
        pp "Row data: #{row.inspect}"
        # Continue with next row instead of failing completely
        next
      end
    end

    if results.empty?
      raise "No valid rows could be processed from the CSV file."
    end

    # Generate output file
    timestamp = if params[:timestamp].present?
                  Time.parse(params[:timestamp]).strftime("%Y%m%d%H%M%S")
                else
                  Time.current.strftime("%Y%m%d%H%M%S")
                end

    new_csv_filename = "#{timestamp}_processed_bids.csv"
    new_csv_path = Rails.root.join('tmp', new_csv_filename)
    headers = results.first.keys

    CSV.open(new_csv_path, 'w', write_headers: true, headers: headers) do |csv|
      results.each { |row| csv << row.values }
    end

    pp "Successfully processed #{results.length} rows and saved to #{new_csv_filename}"
    new_csv_path
  end

  private

  # Detect and read file with proper encoding
  def read_file_with_encoding(file_path)
    # Try different encodings in order of likelihood
    encodings_to_try = [
      'UTF-8',
      'Windows-1252',  # Common for Excel exports
      'ISO-8859-1',    # Latin-1
      'CP1252'         # Windows code page
    ]

    encodings_to_try.each do |encoding|
      begin
        content = File.read(file_path, encoding: encoding)
        # If we successfully read it, convert to UTF-8
        return content.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
        # Try next encoding
        next
      end
    end

    # Fallback: force UTF-8 with replacements
    File.read(file_path, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '')
  end

  def calculate_line_haul_including_fuel(miles, rate)
    PricingMatrix.line_haul_for_miles(miles, rate, fuel_included: true)
  end

  def has_user_specified_columns?(params)
    [params[:origin_column], params[:origin_state_column], params[:destination_column], params[:destination_state_column]].any?(&:present?)
  end

  # Build column mapping using user-specified columns or smart detection
  def build_column_mapping(actual_columns, params)
    mapping = {}
    
    # Handle user-specified origin columns
    if params[:origin_column].present?
      origin_col = find_matching_column(actual_columns, params[:origin_column])
      mapping[:origin] = origin_col if origin_col
    end
    
    if params[:origin_state_column].present?
      origin_state_col = find_matching_column(actual_columns, params[:origin_state_column])
      # If we have both origin and origin_state, treat origin as city and origin_state as state
      if mapping[:origin] && origin_state_col
        mapping[:origin_city] = mapping[:origin]  # Move origin to origin_city
        mapping[:origin] = nil  # Clear the single origin field
        mapping[:origin_state] = origin_state_col
      else
        mapping[:origin_state] = origin_state_col
      end
    end
    
    # Handle user-specified destination columns
    if params[:destination_column].present?
      dest_col = find_matching_column(actual_columns, params[:destination_column])
      mapping[:destination] = dest_col if dest_col
    end
    
    if params[:destination_state_column].present?
      dest_state_col = find_matching_column(actual_columns, params[:destination_state_column])
      # If we have both destination and destination_state, treat destination as city and destination_state as state
      if mapping[:destination] && dest_state_col
        mapping[:destination_city] = mapping[:destination]  # Move destination to destination_city
        mapping[:destination] = nil  # Clear the single destination field
        mapping[:destination_state] = dest_state_col
      else
        mapping[:destination_state] = dest_state_col
      end
    end
    
    # If no user-specified columns, fall back to smart detection
    if mapping.empty? || (!has_origin_mapping?(mapping) || !has_destination_mapping?(mapping))
      pp "No user-specified columns or incomplete mapping, falling back to smart detection"
      smart_mapping = smart_map_columns(actual_columns)
      mapping.merge!(smart_mapping)
    end
    
    mapping
  end

  # Find a column that matches the user-specified name (case-insensitive, flexible matching)
  def find_matching_column(actual_columns, user_specified_name)
    return nil if user_specified_name.blank?
    
    # Clean the user input the same way we clean column names
    user_name = user_specified_name.to_s.downcase.gsub("/", "_").gsub("#", "_num").gsub("%", "_percent").gsub("(", "").gsub(")", "").strip
    
    # Try exact match first
    exact_match = actual_columns.find { |col| col.to_s.downcase == user_name }
    return exact_match if exact_match
    
    # Try partial match (user name contained in column name)
    partial_match = actual_columns.find { |col| col.to_s.downcase.include?(user_name) }
    return partial_match if partial_match
    
    # Try reverse partial match (column name contained in user name)
    reverse_match = actual_columns.find { |col| user_name.include?(col.to_s.downcase) }
    return reverse_match if reverse_match
    
    # Try word-based matching for complex names
    user_words = user_name.split(/\s+|_+/)
    word_match = actual_columns.find do |col|
      col_words = col.to_s.downcase.split(/\s+|_+/)
      # Check if most significant words match
      matching_words = user_words & col_words
      matching_words.length >= [user_words.length * 0.6, 1].max
    end
    return word_match if word_match
    
    pp "WARNING: Could not find column matching '#{user_specified_name}' (cleaned: '#{user_name}') in available columns: #{actual_columns}"
    nil
  end

  # Check if we have origin mapping
  def has_origin_mapping?(mapping)
    mapping[:origin].present? || (mapping[:origin_city].present? || mapping[:origin_state].present?)
  end

  # Check if we have destination mapping
  def has_destination_mapping?(mapping)
    mapping[:destination].present? || (mapping[:destination_city].present? || mapping[:destination_state].present?)
  end

  # Validate that we have the required column mappings
  def validate_required_columns(mapping, actual_columns)
    has_origin = has_origin_mapping?(mapping)
    has_destination = has_destination_mapping?(mapping)
    
    # Check if we're working with numbered columns (indicates no proper headers)
    using_numbered_columns = actual_columns.all? { |col| col.to_s.match?(/^\d+$/) }
    
    # Check if we have suspiciously few columns (might indicate parsing issues)
    if actual_columns.length <= 2
      pp "WARNING: Only found #{actual_columns.length} columns, this might indicate CSV parsing issues"
      pp "Columns found: #{actual_columns}"
    end
    
    error_messages = []
    
    unless has_origin
      error_messages << "Origin column not found. Please specify 'origin_column' (or 'origin_column' + 'origin_state_column' if split)"
    end
    
    unless has_destination
      error_messages << "Destination column not found. Please specify 'destination_column' (or 'destination_column' + 'destination_state_column' if split)"
    end
    
    if error_messages.any?
      error_msg = error_messages.join(". ") + "\n"
      error_msg += "Available columns in your CSV: #{actual_columns.join(', ')}\n"
      
      if using_numbered_columns
        error_msg += "\n🔢 Your CSV appears to have no proper headers, so we're using column numbers.\n"
        error_msg += "📋 Based on your data, here's what each column contains:\n"
        error_msg += get_column_sample_data_description(actual_columns)
        error_msg += "\n💡 Tip: Use the column numbers (like '3', '4', '5') in the form fields.\n"
      else
        error_msg += "\nTip: Copy and paste the exact column names from your CSV file into the form fields."
      end
      
      # Add additional help if very few columns found
      if actual_columns.length <= 2
        error_msg += "\n\nNote: Only #{actual_columns.length} column(s) detected. This might indicate:"
        error_msg += "\n- CSV file format issues (wrong delimiter, encoding, etc.)"
        error_msg += "\n- Headers not in the expected row"
        error_msg += "\n- File may not be a proper CSV format"
      end
      
      raise error_msg
    end
  end

  # Get sample data description for numbered columns
  def get_column_sample_data_description(actual_columns)
    return "" unless @sample_data_for_description
    
    description = ""
    actual_columns.each do |col|
      sample_value = @sample_data_for_description[col] || ""
      # Truncate long values
      display_value = sample_value.to_s.length > 30 ? "#{sample_value.to_s[0..27]}..." : sample_value.to_s
      description += "   Column #{col}: \"#{display_value}\"\n"
    end
    description
  end

  # Dynamic CSV parsing that finds the actual header row
  def parse_csv_with_dynamic_headers(csv_path, params)
    pp "=== DYNAMIC CSV HEADER DETECTION ==="

    # Read raw lines to find header row with proper encoding
    content = read_file_with_encoding(csv_path)
    raw_lines = content.lines.map(&:strip)
    pp "Total lines in file: #{raw_lines.length}"
    
    # Show first 15 lines for debugging
    pp "=== FIRST 15 LINES OF CSV ==="
    raw_lines.first(15).each_with_index do |line, i|
      pp "Line #{i + 1}: #{line}"
    end
    pp "=============================="
    
    # If user specified column names, search for them
    user_specified_columns = get_user_specified_columns(params)
    if user_specified_columns.any?
      pp "=== SEARCHING FOR USER-SPECIFIED COLUMNS ==="
      pp "Looking for: #{user_specified_columns}"
      
      header_row_index = find_row_with_column_names(raw_lines, user_specified_columns)
      if header_row_index
        pp "Found user-specified columns in row #{header_row_index + 1}"
        return parse_csv_starting_after_row(csv_path, header_row_index)
      else
        pp "Could not find user-specified columns in any row"
        # Fall through to automatic detection
      end
    end
    
    # Automatic header detection as fallback
    header_row_index = find_header_row(raw_lines)
    pp "Detected header row at index: #{header_row_index}"
    
    if header_row_index
      return parse_csv_starting_after_row(csv_path, header_row_index)
    end
    
    pp "Could not detect headers, trying fallback parsing"
    return parse_with_fallback(csv_path)
  end

  # Get column names specified by user
  def get_user_specified_columns(params)
    columns = []
    columns << params[:origin_column] if params[:origin_column].present?
    columns << params[:origin_state_column] if params[:origin_state_column].present?
    columns << params[:destination_column] if params[:destination_column].present?
    columns << params[:destination_state_column] if params[:destination_state_column].present?
    columns.compact.map(&:strip).reject(&:blank?)
  end

  # Find the row that contains the specified column names
  def find_row_with_column_names(lines, target_columns)
    lines.each_with_index do |line, index|
      next if line.blank?

      begin
        columns = CSV.parse_line(line, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '')&.map(&:to_s)&.map(&:strip) || []
        next if columns.empty?
        
        pp "Checking row #{index + 1}: #{columns}"
        
        # Check if this row contains all the target column names
        found_columns = []
        target_columns.each do |target|
          matching_col = columns.find { |col| col.downcase.strip == target.downcase.strip }
          if matching_col
            found_columns << target
            pp "  ✓ Found '#{target}' as '#{matching_col}'"
          else
            pp "  ✗ Missing '#{target}'"
          end
        end
        
        # If we found at least one required column, this might be our header row
        if found_columns.length >= target_columns.length * 0.5  # At least 50% match
          pp "Row #{index + 1} has sufficient matches (#{found_columns.length}/#{target_columns.length})"
          return index
        end
        
      rescue CSV::MalformedCSVError => e
        pp "Row #{index + 1} is malformed CSV, skipping: #{e.message}"
        next
      end
    end
    
    nil
  end

  # Parse CSV starting from the row after the header row
  def parse_csv_starting_after_row(csv_path, header_row_index)
    parsing_options = [
      { headers_in_file: true, skip_lines: header_row_index, remove_empty_values: true, strip_whitespace: true, file_encoding: 'UTF-8', invalid_byte_sequence: '' },
      { headers_in_file: true, skip_lines: header_row_index, remove_empty_values: true, strip_whitespace: true, col_sep: ';', file_encoding: 'UTF-8', invalid_byte_sequence: '' },
      { headers_in_file: true, skip_lines: header_row_index, remove_empty_values: true, strip_whitespace: true, col_sep: '\t', file_encoding: 'UTF-8', invalid_byte_sequence: '' }
    ]
    
    parsing_options.each_with_index do |options, i|
      begin
        pp "Parsing attempt #{i + 1} starting after row #{header_row_index + 1}: #{options}"
        csv_data = SmarterCSV.process(csv_path, options)
        
        if csv_data.empty?
          pp "No data found with attempt #{i + 1}, trying next option..."
          next
        end
        
        # Transform keys
        csv_data.map! do |row|
          row.transform_keys! { |key| key.to_s.downcase.gsub("/", "_").gsub("#", "_num").gsub("%", "_percent").gsub("(", "").gsub(")", "").strip.to_sym }
        end
        
        actual_columns = csv_data.first.keys
        if actual_columns.length >= 3
          pp "Successfully parsed: #{csv_data.length} rows, #{actual_columns.length} columns"
          pp "Column names: #{actual_columns}"
          return csv_data
        end
        
      rescue StandardError => e
        pp "Parsing attempt #{i + 1} failed: #{e.message}"
        next
      end
    end
    
    nil
  end

  # Find the header row by looking for patterns
  def find_header_row(lines)
    lines.each_with_index do |line, index|
      next if line.blank?

      # Parse the line as CSV to get columns
      begin
        columns = CSV.parse_line(line, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '')&.map(&:to_s)&.map(&:strip) || []
        next if columns.empty?
        
        pp "Line #{index + 1}: #{columns}"
        
        # Check if this looks like a header row
        if looks_like_header_row?(columns)
          pp "Line #{index + 1} looks like header row"
          return index
        end
        
      rescue CSV::MalformedCSVError
        pp "Line #{index + 1} is malformed CSV, skipping"
        next
      end
    end
    
    nil
  end

  # Determine if a row looks like headers
  def looks_like_header_row?(columns)
    return false if columns.length < 2
    
    # Header indicators
    header_patterns = [
      /lane/i, /origin/i, /destination/i, /ramp/i, /port/i, /city/i, /state/i,
      /location/i, /door/i, /terminal/i, /identifier/i, /region/i, /market/i,
      /corridor/i, /geo/i, /code/i, /priority/i, /volume/i, /zip/i
    ]
    
    # Count how many columns match header patterns
    matches = columns.count do |col|
      header_patterns.any? { |pattern| col.match?(pattern) }
    end
    
    # Consider it a header if at least 40% of columns match patterns
    match_ratio = matches.to_f / columns.length
    pp "Header match ratio for #{columns}: #{match_ratio} (#{matches}/#{columns.length})"
    
    match_ratio >= 0.4
  end

  # Fallback parsing for when header detection fails
  def parse_with_fallback(csv_path)
    parsing_attempts = [
      { skip_lines: 0, col_sep: ',' },
      { skip_lines: 1, col_sep: ',' },
      { skip_lines: 2, col_sep: ',' },
      { skip_lines: 3, col_sep: ',' },
      { skip_lines: 8, col_sep: ',' },
      { skip_lines: 9, col_sep: ',' },
      { skip_lines: 0, col_sep: ';' },
      { skip_lines: 1, col_sep: ';' },
      { skip_lines: 2, col_sep: ';' },
      { skip_lines: 0, col_sep: '\t' },
      { skip_lines: 1, col_sep: '\t' },
      { skip_lines: 2, col_sep: '\t' }
    ]
    
    parsing_attempts.each_with_index do |attempt_params, i|
      begin
        pp "Fallback parsing attempt #{i + 1} with skip_lines: #{attempt_params[:skip_lines]}, delimiter: '#{attempt_params[:col_sep]}'"
        
        options = {
          headers_in_file: true,
          skip_lines: attempt_params[:skip_lines],
          remove_empty_values: true,
          strip_whitespace: true,
          col_sep: attempt_params[:col_sep],
          file_encoding: 'UTF-8',
          invalid_byte_sequence: ''
        }
        
        csv_data = SmarterCSV.process(csv_path, options)
        next if csv_data.empty?
        
        # Transform keys
        csv_data.map! do |row|
          row.transform_keys! { |key| key.to_s.downcase.gsub("/", "_").gsub("#", "_num").gsub("%", "_percent").strip.to_sym }
        end
        
        # Check if we got reasonable column names and count
        actual_columns = csv_data.first.keys
        if actual_columns.length >= 2 && 
           !actual_columns.all? { |col| col.to_s.match?(/^\d+$/) || col.to_s.length <= 2 }
          pp "Fallback parsing successful: #{csv_data.length} rows, #{actual_columns.length} columns"
          pp "Columns: #{actual_columns}"
          return csv_data
        else
          pp "Found #{actual_columns.length} columns but they look suspicious: #{actual_columns}"
          next
        end
        
      rescue StandardError => e
        pp "Fallback attempt #{i + 1} failed: #{e.message}"
        next
      end
    end
    
    pp "All fallback parsing attempts failed"
    nil
  end

  # Extract origin information from row
  def extract_origin(row, mapping)
    if mapping[:origin]
      location = get_value_from_row(row, mapping[:origin])
      { location: location }
    elsif mapping[:origin_city] && mapping[:origin_state]
      city = get_value_from_row(row, mapping[:origin_city])
      state = get_value_from_row(row, mapping[:origin_state])
      location = "#{city}, #{state}".strip.gsub(/^,|,$/, '')
      { location: location, city: city, state: state }
    elsif mapping[:origin_city]
      # Only city, no state
      city = get_value_from_row(row, mapping[:origin_city])
      { location: city, city: city, state: nil }
    else
      { location: nil }
    end
  end

  # Extract destination information from row
  def extract_destination(row, mapping)
    if mapping[:destination_city] && mapping[:destination_state]
      city = get_value_from_row(row, mapping[:destination_city])
      state = get_value_from_row(row, mapping[:destination_state])
      location = "#{city}, #{state}".strip.gsub(/^,|,$/, '')
      {
        location: location,
        city: city,
        state: state,
        display: "#{city}, #{state}"
      }
    elsif mapping[:destination]
      location = get_value_from_row(row, mapping[:destination])
      # Try to parse city, state from combined field
      if location && location.include?(',')
        parts = location.split(',').map(&:strip)
        city = parts[0]
        state = parts[1] if parts.length > 1
        {
          location: location,
          city: city,
          state: state,
          display: location
        }
      else
        {
          location: location,
          city: location,
          state: nil,
          display: location
        }
      end
    elsif mapping[:destination_city]
      # Only city, no state
      city = get_value_from_row(row, mapping[:destination_city])
      {
        location: city,
        city: city,
        state: nil,
        display: city
      }
    else
      { location: nil, display: nil }
    end
  end

  # Add optional fields to result row
  def add_optional_fields(result_row, row, mapping)
    optional_field_mappings = {
      'Lane ID' => [:lane_id],
      'Ramp Code' => [:ramp_code],
      'Lane Priority' => [:lane_priority],
      'Weekly Volume' => [:weekly_volume],
      'ZIP Code' => [:zip_code],
      'LN and FSC' => [:ln_and_fsc]
    }

    optional_field_mappings.each do |display_name, field_keys|
      field_keys.each do |field_key|
        if mapping[field_key]
          value = get_value_from_row(row, mapping[field_key])
          result_row[display_name] = value if value.present?
          break
        end
      end
    end
  end

  # Improved smart column mapping (fallback only)
  def smart_map_columns(columns)
    mapping = {}
    
    # Define field patterns for different column types
    field_patterns = {
      # Origin patterns (including combined and split)
      origin: [
        /^origin$/i, /^origin.*location$/i, /^ramp$/i, /^ramp.*location$/i,
        /^port$/i, /^terminal$/i, /^facility$/i, /^pickup/i, /^loading/i
      ],
      origin_city: [
        /origin.*city/i, /pickup.*city/i, /loading.*city/i
      ],
      origin_state: [
        /origin.*state/i, /pickup.*state/i, /loading.*state/i
      ],
      
      # Destination patterns (including combined and split)  
      destination: [
        /^destination$/i, /^city$/i, /^destination.*location$/i,
        /^door.*location/i, /^delivery.*location/i, /^drop.*location/i,
        /^unload.*location/i, /^consignee.*location/i
      ],
      destination_city: [
        /destination.*city/i, /delivery.*city/i, /consignee.*city/i,
        /door.*city/i, /drop.*city/i, /unload.*city/i
      ],
      destination_state: [
        /destination.*state/i, /delivery.*state/i, /consignee.*state/i,
        /door.*location.*state/i, /door.*state/i, /^state$/i
      ],
      
      # Optional fields
      lane_id: [/lane.*id/i, /lane.*num/i, /^lane$/i, /identifier/i],
      ramp_code: [/ramp.*code/i, /port.*code/i, /terminal.*code/i],
      lane_priority: [/priority/i, /ranking/i, /rank/i],
      weekly_volume: [/volume/i, /weekly.*volume/i],
      zip_code: [/zip/i, /zip.*code/i, /postal/i],
      ln_and_fsc: [/ln.*fsc/i, /line.*haul/i, /fuel.*surcharge/i]
    }

    # Try to match each field
    field_patterns.each do |field, patterns|
      matched_column = find_best_column_match(field, patterns, columns)
      mapping[field] = matched_column if matched_column
    end

    # Ensure we have at least basic origin and destination mapping
    if mapping[:origin].nil? && mapping[:origin_city].nil?
      mapping[:origin] = find_fallback_origin_column(columns)
    end
    
    if mapping[:destination].nil? && mapping[:destination_city].nil?
      mapping[:destination] = find_fallback_destination_column(columns)
    end

    mapping
  end

  # Find the best column match for a field
  def find_best_column_match(field, patterns, columns)
    # Try exact pattern matches first
    patterns.each do |pattern|
      match = columns.find { |col| col.to_s.match?(pattern) }
      return match if match
    end
    
    # Try fuzzy matching if no exact match
    fuzzy_match_column(field, columns)
  end

  # Find fallback origin column
  def find_fallback_origin_column(columns)
    origin_keywords = %w[origin ramp port terminal pickup loading facility from]
    find_column_with_keywords(columns, origin_keywords)
  end

  # Find fallback destination column  
  def find_fallback_destination_column(columns)
    dest_keywords = %w[destination city delivery door drop unload consignee to]
    find_column_with_keywords(columns, dest_keywords)
  end

  # Find column containing any of the keywords
  def find_column_with_keywords(columns, keywords)
    columns.find do |col|
      col_str = col.to_s.downcase
      keywords.any? { |keyword| col_str.include?(keyword) }
    end
  end

  # Fuzzy matching for column names (improved)
  def fuzzy_match_column(field, columns)
    field_keywords = {
      origin: %w[origin ramp port terminal facility pickup loading from],
      destination: %w[destination city delivery door drop unload consignee to],
      destination_city: %w[destination delivery city door location drop unload consignee],
      destination_state: %w[state destination delivery consignee door],
      lane_id: %w[lane route id identifier],
      ramp_code: %w[ramp port terminal code],
      lane_priority: %w[lane priority rank ranking],
      weekly_volume: %w[volume weekly],
      zip_code: %w[zip postal code],
      ln_and_fsc: %w[ln fsc line haul fuel surcharge]
    }

    keywords = field_keywords[field] || []
    return nil if keywords.empty?

    # Score each column based on keyword matches
    scored_columns = columns.map do |col|
      col_str = col.to_s.downcase
      score = keywords.count { |keyword| col_str.include?(keyword) }
      [col, score]
    end

    # Return the column with the highest score (if > 0)
    best_match = scored_columns.max_by { |_, score| score }
    best_match && best_match[1] > 0 ? best_match[0] : nil
  end

  # Safely get value from row using column mapping
  def get_value_from_row(row, column_key)
    return nil unless column_key
    
    value = row[column_key]
    value.is_a?(String) ? value.strip : value
  end

  # Legacy method for backward compatibility
  def map_column_name(column_name)
    column_str = column_name.to_s.downcase.strip
    
    # Ramp/Port location variations
    if column_str.match?(/ramp|port|terminal|facility|origin|origin_address/)
      return :ramp_port_location
    end
    
    # City variations (including destination city)
    if column_str.match?(/city|destination.*city|destination_city|consignee.*city|shipper.*city|delivery.*city/)
      return :consignee_shipper_city
    end
    
    # State variations
    if column_str.match?(/state|destination.*state|consignee.*state|shipper.*state|delivery.*state/)
      return :consignee_shipper_state
    end
    
    # Miles/Distance variations
    if column_str.match?(/miles|mileage|distance|one_way_miles|oneway_miles|trip_miles|route_miles|total_miles/)
      return :miles
    end
    
    # RC Number variations (including rc_num from the CSV)
    if column_str.match?(/rc|rc_number|rc_num|reference|ref_number|ref_num/)
      return :rc_number
    end
    
    # Lane ID variations
    if column_str.match?(/lane|lane_id|lane_number|lane_num|route_id|route_number/)
      return :lane_id
    end
    
    # Fixed Fuel variations (including fixed_fuel_percent from the CSV)
    if column_str.match?(/fuel|fixed_fuel|fuel_percent|fuel_pct|fsc|fuel_surcharge|fixed_fuel_percent/)
      return :fixed_fuel_percent
    end
    
    # Return original if no mapping found
    column_name
  end

  def parse_csv_with_user_columns(file_path, params)
    Rails.logger.info "=== PARSING CSV WITH USER-SPECIFIED COLUMNS ==="
    Rails.logger.info "User specified columns: #{[params[:origin_column], params[:origin_state_column], params[:destination_column], params[:destination_state_column]].compact}"
    
    # Get the column names we're looking for
    search_columns = [
      params[:origin_column],
      params[:origin_state_column], 
      params[:destination_column],
      params[:destination_state_column]
    ].compact.reject(&:blank?)
    
    Rails.logger.info "Searching for columns: #{search_columns}"
    
    if search_columns.empty?
      Rails.logger.info "No user columns specified, falling back to smart detection"
      return { data: parse_csv_with_dynamic_headers(file_path, params), headers: [], total_rows: 0 }
    end
    
    header_row_index = nil
    column_positions = {}
    
    # Read CSV line by line to find header row
    current_line = 0
    CSV.foreach(file_path, headers: false, liberal_parsing: true, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '') do |row|
      current_line += 1
      next if row.nil? || row.empty?
      
      Rails.logger.info "Checking row #{current_line}: #{row.to_a.inspect}"
      
      # Check if this row contains all our search columns
      found_columns = {}
      search_columns.each do |search_col|
        row.each_with_index do |cell, col_index|
          if cell.to_s.strip.downcase == search_col.to_s.strip.downcase
            found_columns[search_col] = col_index
            Rails.logger.info "  ✓ Found '#{search_col}' at column #{col_index}"
            break
          end
        end
      end
      
      # If we found all columns, this is our header row
      if found_columns.size == search_columns.size
        header_row_index = current_line
        column_positions = found_columns
        Rails.logger.info "🎉 FOUND HEADER ROW at line #{header_row_index}!"
        Rails.logger.info "Column positions: #{column_positions}"
        break
      else
        missing = search_columns - found_columns.keys
        Rails.logger.info "  ✗ Missing columns: #{missing}"
      end
    end
    
    if header_row_index.nil?
      Rails.logger.error "Could not find header row containing all specified columns: #{search_columns}"
      Rails.logger.info "Falling back to smart detection"
      return { data: parse_csv_with_dynamic_headers(file_path, params), headers: [], total_rows: 0 }
    end
    
    # Now parse the CSV starting from the row after the header
    data_start_row = header_row_index + 1
    Rails.logger.info "Starting data parsing from row #{data_start_row}"
    
    parsed_data = []
    row_count = 0
    current_row = 0

    CSV.foreach(file_path, headers: false, liberal_parsing: true, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '') do |row|
      current_row += 1
      
      # Skip until we reach the data start row
      next if current_row < data_start_row
      next if row.nil? || row.empty?
      
      row_count += 1
      
      # Log first few rows for debugging
      if row_count <= 5
        Rails.logger.info "Processing row #{current_row}: #{row.to_a.inspect}"
      end
      
      # Extract data using our found column positions
      origin_data = extract_column_data(row, column_positions, params[:origin_column])
      origin_state_data = extract_column_data(row, column_positions, params[:origin_state_column])
      destination_data = extract_column_data(row, column_positions, params[:destination_column])
      destination_state_data = extract_column_data(row, column_positions, params[:destination_state_column])
      
      # Log extraction results for debugging
      if row_count <= 5
        Rails.logger.info "  Origin data: '#{origin_data}', Origin state: '#{origin_state_data}'"
        Rails.logger.info "  Destination data: '#{destination_data}', Destination state: '#{destination_state_data}'"
      end
      
      # Build the origin and destination strings
      origin = build_location_string(origin_data, origin_state_data)
      destination = build_location_string(destination_data, destination_state_data)
      
      # Log final strings for debugging
      if row_count <= 5
        Rails.logger.info "  Final origin: '#{origin}', Final destination: '#{destination}'"
      end
      
      if origin.present? && destination.present?
        parsed_data << {
          origin: origin,
          destination: destination,
          row_number: current_row
        }
        
        if row_count <= 3  # Log first few rows for debugging
          Rails.logger.info "✓ Row #{current_row}: #{origin} → #{destination}"
        end
      else
        if row_count <= 5
          Rails.logger.info "✗ Skipping row #{current_row}: origin='#{origin}', destination='#{destination}'"
        end
      end
    end
    
    Rails.logger.info "Successfully parsed #{parsed_data.size} rows using user-specified columns"
    
    {
      data: parsed_data,
      headers: search_columns,
      total_rows: parsed_data.size
    }
  end
  
  private
  
  def extract_column_data(row, column_positions, column_name)
    return nil if column_name.blank?
    
    col_index = column_positions[column_name]
    return nil if col_index.nil?
    
    row[col_index]&.to_s&.strip
  end
  
  def build_location_string(primary_data, secondary_data)
    parts = [primary_data, secondary_data].compact.reject(&:blank?)
    parts.join(', ')
  end
end
