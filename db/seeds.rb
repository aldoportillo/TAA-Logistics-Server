# Clear existing data
puts "Clearing existing data..."
Quote.destroy_all
Bid.destroy_all
Port.destroy_all
PricingMatrix.destroy_all
User.destroy_all

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@taalogistics.com',
  password: 'password',
  role: 'admin',
  phone_number: '555-0001'
)

# Create broker user
puts "Creating broker user..."
broker = User.create!(
  email: 'broker@taalogistics.com',
  password: 'password',
  role: 'broker',
  phone_number: '555-0002'
)

# Create ports
puts "Creating ports..."
ports = [
  { name: 'CN Harvey', address: '16800 Center St, Harvey, IL 60426', active: true },
  { name: 'BNSF LPC / UP Global IV', address: '3000 Centerpoint Way, Joliet, IL 60436', active: true },
  { name: 'CP Rails', address: '10800 Franklin Ave, Franklin Park, IL 60131', active: true },
  { name: 'CSX/NS Chicago', address: '2101 W 59th St, Chicago, IL 60636', active: true },
  { name: 'CHICAGO, IL - NORFOLK SOUTHERN - LANDERS (I104)', address: '7600 S Western Ave, Chicago, IL 60620', active: true },
  { name: 'CHICAGO, IL - BNSF - CHICAGO - LPC (H572)', address: '26664 Elwood International Port Rd, Elwood, IL, 60421, USA', active: true },
  { name: 'CHICAGO, IL - UP JOLIET INTERMODAL TERMINAL GLOBAL 4 (I206)', address: '3000 Centerpoint Way, Joliet, IL 60436', active: true },
  { name: 'CHICAGO, IL - CN RAIL - CHICAGO - HARVEY (I092)', address: '16800 Center St, Harvey, IL 60426', active: true },
  { name: 'CHICAGO, IL - CSX (J470)', address: '2101 W 59th St, Chicago, IL 60636', active: true },
  { name: 'CHICAGO, IL - CP RAIL - CHICAGO, BENSENVILLE (J830)', address: '10800 Franklin Ave, Franklin Park, IL 60131', active: true }
]

ports.each do |port_data|
  Port.create!(port_data)
end

# Create pricing matrices
puts "Creating pricing matrices..."
pricing_matrices = [
  { start_miles: 0, end_miles: 20, line_haul_plus_29_5_fuel_surcharge: 375.00, line_haul: 289.58 },
  { start_miles: 20, end_miles: 40, line_haul_plus_29_5_fuel_surcharge: 375.00, line_haul: 289.58 },
  { start_miles: 40, end_miles: 60, line_haul_plus_29_5_fuel_surcharge: 400.00, line_haul: 308.88 },
  { start_miles: 60, end_miles: 80, line_haul_plus_29_5_fuel_surcharge: 425.00, line_haul: 328.19 },
  { start_miles: 80, end_miles: 90, line_haul_plus_29_5_fuel_surcharge: 450.00, line_haul: 347.49 },
  { start_miles: 90, end_miles: 100, line_haul_plus_29_5_fuel_surcharge: 475.00, line_haul: 366.80 },
  { start_miles: 100, end_miles: 120, line_haul_plus_29_5_fuel_surcharge: 500.00, line_haul: 386.10 },
  { start_miles: 120, end_miles: 140, line_haul_plus_29_5_fuel_surcharge: 550.00, line_haul: 424.71 },
  { start_miles: 140, end_miles: 160, line_haul_plus_29_5_fuel_surcharge: 600.00, line_haul: 463.32 },
  { start_miles: 160, end_miles: 200, line_haul_plus_29_5_fuel_surcharge: 700.00, line_haul: 540.54 },
  { start_miles: 200, end_miles: 250, line_haul_plus_29_5_fuel_surcharge: 750.00, line_haul: 579.15 },
  { start_miles: 250, end_miles: 300, line_haul_plus_29_5_fuel_surcharge: 850.00, line_haul: 656.37 },
  { start_miles: 300, end_miles: 360, line_haul_plus_29_5_fuel_surcharge: 950.00, line_haul: 733.59 },
  { start_miles: 360, end_miles: 380, line_haul_plus_29_5_fuel_surcharge: 1000.00, line_haul: 772.20 },
  { start_miles: 380, end_miles: 400, line_haul_plus_29_5_fuel_surcharge: 1050.00, line_haul: 810.81 }
]

pricing_matrices.each do |matrix_data|
  PricingMatrix.create!(matrix_data)
end

# Create employee quotes
puts "Creating employee quotes..."
employee_quotes = [
  {
    company_name: 'ABC Logistics',
    contact_name: 'John Smith',
    email: 'john@abclogistics.com',
    phone: '555-1001',
    from: '18949 Wolf Rd, Mokena, IL 60448',
    rail_destination: 'CN Harvey',
    created_by_employee: true,
    miles: 900,
    line_haul: 600,
    fsch_percent: 25,
  },
  {
    company_name: 'XYZ Transport',
    contact_name: 'Sarah Johnson',
    email: 'sarah@xyztransport.com',
    phone: '555-1002',
    from: '18949 Wolf Rd, Mokena, IL 60448',
    rail_destination: 'BNSF LPC / UP Global IV',
    created_by_employee: true,
    miles: 200,
    line_haul: 500,
    fsch_percent: 25,
  }
]

employee_quotes.each do |quote_data|
  Quote.create!(quote_data)
end

# Create customer quotes
puts "Creating customer quotes..."
customer_quotes = [
  {
    company_name: 'Global Shipping Co',
    contact_name: 'Mike Wilson',
    email: 'mike@globalshipping.com',
    phone: '555-2001',
    from: '18949 Wolf Rd, Mokena, IL 60448',
    rail_destination: 'CP Rails',
    created_by_employee: false,
    miles: 700,
    line_haul: 200,
    fsch_percent: 25,
  },
  {
    company_name: 'Ocean Freight Inc',
    contact_name: 'Lisa Brown',
    email: 'lisa@oceanfreight.com',
    phone: '555-2002',
    from: '18949 Wolf Rd, Mokena, IL 60448',
    rail_destination: 'CSX/NS Chicago',
    created_by_employee: false,
    miles: 500,
    line_haul: 200,
    fsch_percent: 25,
  }
]

customer_quotes.each do |quote_data|
  Quote.create!(quote_data)
end

puts "Seed data created successfully!"
