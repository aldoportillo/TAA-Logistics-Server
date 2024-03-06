json.extract! quote, :id, :company_name, :contact_name, :email, :phone, :fax, :commodity, :commodity_temp, :commodity_gross_weight, :from, :delivery_date, :delivery_zip_code, :shipping_date, :shipping_zip_code, :CS, :container_size, :pallets, :equipment_type, :rail_destination, :questions_or_notes, :created_at, :updated_at
json.url quote_url(quote, format: :json)
