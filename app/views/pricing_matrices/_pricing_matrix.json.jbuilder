json.extract! pricing_matrix, :id, :start_miles, :end_miles, :price, :created_at, :updated_at
json.url pricing_matrix_url(pricing_matrix, format: :json)
