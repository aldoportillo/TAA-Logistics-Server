# Create admin user
User.find_or_create_by!(
  email: ENV['MAILER_EMAIL'] || 'admin@example.com'
) do |user|
  user.password = ENV['ADMIN_PASSWORD'] || 'password123'
  user.password_confirmation = ENV['ADMIN_PASSWORD'] || 'password123'
  user.role = 'admin'
  user.name = 'Ed'
  user.phone_number = '1234567890'  # Adding required phone number
end

# Clear existing data
PricingMatrix.destroy_all

# Define the pricing data (inclusive/exclusive: [start_miles, end_miles))
pricing_data = [
  { start_miles: 0, end_miles: 20, line_haul_plus_29_5_fuel_surcharge: 375.00 },
  { start_miles: 20, end_miles: 40, line_haul_plus_29_5_fuel_surcharge: 375.00 },
  { start_miles: 40, end_miles: 60, line_haul_plus_29_5_fuel_surcharge: 400.00 },
  { start_miles: 60, end_miles: 80, line_haul_plus_29_5_fuel_surcharge: 425.00 },
  { start_miles: 80, end_miles: 90, line_haul_plus_29_5_fuel_surcharge: 450.00 },
  { start_miles: 90, end_miles: 100, line_haul_plus_29_5_fuel_surcharge: 475.00 },
  { start_miles: 100, end_miles: 120, line_haul_plus_29_5_fuel_surcharge: 500.00 },
  { start_miles: 120, end_miles: 140, line_haul_plus_29_5_fuel_surcharge: 550.00 },
  { start_miles: 140, end_miles: 160, line_haul_plus_29_5_fuel_surcharge: 600.00 },
  { start_miles: 160, end_miles: 200, line_haul_plus_29_5_fuel_surcharge: 700.00 },
  { start_miles: 200, end_miles: 250, line_haul_plus_29_5_fuel_surcharge: 750.00 },
  { start_miles: 250, end_miles: 300, line_haul_plus_29_5_fuel_surcharge: 850.00 },
  { start_miles: 300, end_miles: 360, line_haul_plus_29_5_fuel_surcharge: 950.00 },
  { start_miles: 360, end_miles: 380, line_haul_plus_29_5_fuel_surcharge: 1000.00 },
  { start_miles: 380, end_miles: 400, line_haul_plus_29_5_fuel_surcharge: 1050.00 }
]

# Create records one by one
pricing_data.each do |data|
  PricingMatrix.create!(
    start_miles: data[:start_miles],
    end_miles: data[:end_miles],
    line_haul_plus_29_5_fuel_surcharge: data[:line_haul_plus_29_5_fuel_surcharge],
    line_haul: (data[:line_haul_plus_29_5_fuel_surcharge] / 1.295).round(2)
  )
end

puts "Created #{PricingMatrix.count} pricing matrix records"
