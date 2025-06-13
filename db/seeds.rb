# Clear existing data (except ports and pricing matrices which we want to preserve)
puts "Clearing existing data..."
Application.destroy_all
Quote.destroy_all
Inquiry.destroy_all
Event.destroy_all
Image.destroy_all
Bid.destroy_all
User.destroy_all

# Create users with different roles
puts "Creating users..."
admin = User.create!(
  name: 'Admin User',
  email: 'admin@taalogistics.com',
  password: 'password',
  role: 'admin',
  phone_number: '(555) 001-0001'
)

broker = User.create!(
  name: 'Broker User',
  email: 'broker@taalogistics.com',
  password: 'password',
  role: 'broker',
  phone_number: '(555) 001-0002'
)

# Only create ports and pricing matrices if they don't exist
if Port.count == 0
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
else
  puts "Ports already exist, skipping..."
end

if PricingMatrix.count == 0
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
else
  puts "Pricing matrices already exist, skipping..."
end

# Create comprehensive quotes data
puts "Creating employee quotes..."
employee_quotes = [
  {
    company_name: 'ABC Logistics Solutions',
    contact_name: 'Robert Chen',
    email: 'robert.chen@abclogistics.com',
    phone: '(312) 555-1001',
    fax: '(312) 555-1002',
    commodity: 'Electronics',
    commodity_temp: 65,
    commodity_gross_weight: 45000,
    from: 'Los Angeles, CA',
    destination: 'Chicago, IL',
    delivery_date: Date.current + 7.days,
    delivery_zip_code: '60601',
    shipping_date: Date.current + 2.days,
    shipping_zip_code: '90210',
    CS: 1,
    container_size: '40ft',
    pallets: 20,
    equipment_type: 'Dry Van',
    rail_destination: 'CN Harvey',
    questions_or_notes: 'Temperature sensitive cargo, handle with care',
    contacted: false,
    rate_per_mile: 2.50,
    fsch_percent: 29.5,
    miles: 2015.0,
    line_haul: 5037.50,
    fuel_surcharge: 1486.06,
    total: 6523.56,
    created_by_employee: true
  },
  {
    company_name: 'XYZ Manufacturing Corp',
    contact_name: 'Jennifer Williams',
    email: 'j.williams@xyzmanufacturing.com',
    phone: '(773) 555-2001',
    fax: '(773) 555-2002',
    commodity: 'Auto Parts',
    commodity_temp: 70,
    commodity_gross_weight: 38000,
    from: 'Detroit, MI',
    destination: 'Chicago, IL',
    delivery_date: Date.current + 5.days,
    delivery_zip_code: '60602',
    shipping_date: Date.current + 1.day,
    shipping_zip_code: '48201',
    CS: 2,
    container_size: '20ft',
    pallets: 15,
    equipment_type: 'Flatbed',
    rail_destination: 'BNSF LPC / UP Global IV',
    questions_or_notes: 'Fragile items, secure loading required',
    contacted: true,
    rate_per_mile: 2.75,
    fsch_percent: 29.5,
    miles: 283.0,
    line_haul: 778.25,
    fuel_surcharge: 229.58,
    total: 1007.83,
    created_by_employee: true
  },
  {
    company_name: 'Global Trade Partners',
    contact_name: 'David Rodriguez',
    email: 'david.r@globaltradepart.com',
    phone: '(630) 555-3001',
    commodity: 'Textiles',
    commodity_gross_weight: 25000,
    from: 'Houston, TX',
    destination: 'Chicago, IL',
    delivery_date: Date.current + 10.days,
    delivery_zip_code: '60603',
    shipping_date: Date.current + 3.days,
    shipping_zip_code: '77001',
    container_size: '40ft',
    pallets: 18,
    equipment_type: 'Dry Van',
    rail_destination: 'CP Rails',
    questions_or_notes: 'Standard delivery, no special requirements',
    contacted: false,
    rate_per_mile: 2.25,
    fsch_percent: 29.5,
    miles: 1087.0,
    line_haul: 2445.75,
    fuel_surcharge: 721.50,
    total: 3167.25,
    created_by_employee: true
  }
]

employee_quotes.each do |quote_data|
  Quote.create!(quote_data)
end

puts "Creating customer quotes..."
customer_quotes = [
  {
    company_name: 'Midwest Distribution Inc',
    contact_name: 'Lisa Thompson',
    email: 'lisa.thompson@midwestdist.com',
    phone: '(847) 555-4001',
    commodity: 'Food Products',
    commodity_temp: 35,
    commodity_gross_weight: 42000,
    from: 'Milwaukee, WI',
    destination: 'Chicago, IL',
    delivery_date: Date.current + 4.days,
    delivery_zip_code: '60604',
    shipping_date: Date.current + 1.day,
    shipping_zip_code: '53201',
    container_size: '53ft',
    pallets: 22,
    equipment_type: 'Refrigerated',
    rail_destination: 'CSX/NS Chicago',
    questions_or_notes: 'Refrigerated transport required, maintain 35°F',
    contacted: false,
    rate_per_mile: 3.00,
    fsch_percent: 29.5,
    miles: 92.0,
    line_haul: 276.00,
    fuel_surcharge: 81.42,
    total: 357.42,
    created_by_employee: false
  },
  {
    company_name: 'Pacific Imports LLC',
    contact_name: 'Kevin Park',
    email: 'kevin.park@pacificimports.com',
    phone: '(708) 555-5001',
    commodity: 'Consumer Goods',
    commodity_gross_weight: 35000,
    from: 'Seattle, WA',
    destination: 'Chicago, IL',
    delivery_date: Date.current + 12.days,
    delivery_zip_code: '60605',
    shipping_date: Date.current + 5.days,
    shipping_zip_code: '98101',
    container_size: '40ft',
    pallets: 16,
    equipment_type: 'Dry Van',
    rail_destination: 'CHICAGO, IL - NORFOLK SOUTHERN - LANDERS (I104)',
    questions_or_notes: 'Standard shipping, no special handling',
    contacted: true,
    rate_per_mile: 2.40,
    fsch_percent: 29.5,
    miles: 2064.0,
    line_haul: 4953.60,
    fuel_surcharge: 1461.31,
    total: 6414.91,
    created_by_employee: false
  }
]

customer_quotes.each do |quote_data|
  Quote.create!(quote_data)
end

# Create driver applications
puts "Creating driver applications..."
applications = [
  {
    first_name: 'Michael',
    middle_initial: 'J',
    last_name: 'Anderson',
    address: '1234 Oak Street',
    city: 'Chicago',
    state: 'IL',
    zip: '60601',
    birthday: Date.new(1985, 3, 15),
    ssn: '123-45-6789',
    phone_number: '(312) 555-7001',
    email: 'michael.anderson@email.com',
    residency_address_1: '1234 Oak Street',
    residency_city_1: 'Chicago',
    residency_state_1: 'IL',
    residency_zip_1: '60601',
    residency_address_2: '5678 Pine Avenue',
    residency_city_2: 'Milwaukee',
    residency_state_2: 'WI',
    residency_zip_2: '53201',
    license_state: 'IL',
    license_number: 'A123456789',
    license_type: 'CDL Class A',
    license_expiration_date: Date.current + 2.years,
    experience_class_1: 'Class A',
    experience_type_1: 'Over the Road',
    experience_start_date_1: Date.new(2018, 1, 1),
    experience_end_date_1: Date.new(2023, 12, 31),
    experience_miles_1: 500000,
    experience_class_2: 'Class B',
    experience_type_2: 'Local Delivery',
    experience_start_date_2: Date.new(2015, 6, 1),
    experience_end_date_2: Date.new(2017, 12, 31),
    experience_miles_2: 150000,
    contacted: false
  },
  {
    first_name: 'Sarah',
    middle_initial: 'M',
    last_name: 'Davis',
    address: '9876 Maple Drive',
    city: 'Naperville',
    state: 'IL',
    zip: '60540',
    birthday: Date.new(1990, 7, 22),
    ssn: '987-65-4321',
    phone_number: '(630) 555-8001',
    email: 'sarah.davis@email.com',
    residency_address_1: '9876 Maple Drive',
    residency_city_1: 'Naperville',
    residency_state_1: 'IL',
    residency_zip_1: '60540',
    license_state: 'IL',
    license_number: 'B987654321',
    license_type: 'CDL Class A',
    license_expiration_date: Date.current + 3.years,
    conviction_date_1: Date.new(2019, 5, 10),
    conviction_violation_1: 'Speeding',
    conviction_state_1: 'IL',
    conviction_penalty_1: '$150 Fine',
    experience_class_1: 'Class A',
    experience_type_1: 'Regional',
    experience_start_date_1: Date.new(2020, 3, 1),
    experience_end_date_1: Date.current,
    experience_miles_1: 300000,
    accident_date_1: Date.new(2021, 8, 15),
    accident_nature_1: 'Rear-end collision',
    accident_fatalities_1: 0,
    accident_injuries_1: 1,
    accident_spill_1: false,
    contacted: true
  },
  {
    first_name: 'Carlos',
    middle_initial: 'R',
    last_name: 'Martinez',
    address: '4567 Elm Street',
    city: 'Aurora',
    state: 'IL',
    zip: '60502',
    birthday: Date.new(1982, 11, 8),
    ssn: '456-78-9123',
    phone_number: '(630) 555-9001',
    email: 'carlos.martinez@email.com',
    residency_address_1: '4567 Elm Street',
    residency_city_1: 'Aurora',
    residency_state_1: 'IL',
    residency_zip_1: '60502',
    residency_address_2: '1122 Cedar Lane',
    residency_city_2: 'Rockford',
    residency_state_2: 'IL',
    residency_zip_2: '61101',
    residency_address_3: '3344 Birch Road',
    residency_city_3: 'Peoria',
    residency_state_3: 'IL',
    residency_zip_3: '61601',
    license_state: 'IL',
    license_number: 'C456789123',
    license_type: 'CDL Class A with Hazmat',
    license_expiration_date: Date.current + 1.year,
    experience_class_1: 'Class A',
    experience_type_1: 'Over the Road',
    experience_start_date_1: Date.new(2010, 1, 1),
    experience_end_date_1: Date.current,
    experience_miles_1: 1200000,
    experience_class_2: 'Class A',
    experience_type_2: 'Hazmat',
    experience_start_date_2: Date.new(2015, 1, 1),
    experience_end_date_2: Date.current,
    experience_miles_2: 800000,
    contacted: false
  }
]

applications.each do |app_data|
  Application.create!(app_data)
end

# Create inquiries
puts "Creating inquiries..."
inquiries = [
  {
    name: 'Amanda Foster',
    phone_number: '(312) 555-6001',
    email_address: 'amanda.foster@company.com',
    message: 'Hi, I need a quote for shipping 20 pallets of electronics from Los Angeles to Chicago. The shipment needs to be delivered by next Friday. Can you provide pricing and availability?',
    contacted: false
  },
  {
    name: 'James Wilson',
    phone_number: '(773) 555-6002',
    email_address: 'james.wilson@manufacturing.com',
    message: 'We have a regular shipping route from Detroit to Chicago and are looking for a reliable logistics partner. We ship approximately 15-20 loads per month. Please contact me to discuss rates.',
    contacted: true
  },
  {
    name: 'Maria Gonzalez',
    phone_number: '(630) 555-6003',
    email_address: 'maria.g@imports.com',
    message: 'I need information about your refrigerated transport services. We import frozen foods and need temperature-controlled shipping from the port to our distribution center.',
    contacted: false
  },
  {
    name: 'Thomas Lee',
    phone_number: '(847) 555-6004',
    email_address: 'thomas.lee@retailchain.com',
    message: 'Our company is expanding and we need a logistics partner for our Chicago operations. We handle consumer goods and need both inbound and outbound shipping services.',
    contacted: true
  }
]

inquiries.each do |inquiry_data|
  Inquiry.create!(inquiry_data)
end

# Create events
puts "Creating events..."
events = [
  {
    name: 'Annual Safety Training',
    description: 'Comprehensive safety training session for all drivers and logistics personnel. Topics include defensive driving, cargo handling, and emergency procedures.'
  },
  {
    name: 'Customer Appreciation BBQ',
    description: 'Annual customer appreciation event featuring BBQ lunch, facility tours, and networking opportunities with our logistics team.'
  },
  {
    name: 'New Equipment Showcase',
    description: 'Demonstration of our latest fleet additions including new refrigerated trailers and GPS tracking systems.'
  },
  {
    name: 'Industry Conference Participation',
    description: 'TAA Logistics participation in the Midwest Transportation and Logistics Conference, showcasing our services and networking with industry partners.'
  }
]

events.each do |event_data|
  event = Event.create!(event_data)
  
  # Create sample images for each event
  2.times do |i|
    Image.create!(
      event: event,
      url: "https://example.com/event_#{event.id}_image_#{i + 1}.jpg"
    )
  end
end

# Create some basic bids (since the table is minimal)
puts "Creating bids..."
5.times do
  Bid.create!
end

puts "✅ Comprehensive seed data created successfully!"
puts "📊 Created:"
puts "   - #{User.count} users (admin, brokers, regular user)"
puts "   - #{Port.count} ports (ramp locations)"
puts "   - #{PricingMatrix.count} pricing matrix entries"
puts "   - #{Quote.count} quotes (employee and customer)"
puts "   - #{Application.count} driver applications"
puts "   - #{Inquiry.count} customer inquiries"
puts "   - #{Event.count} events with #{Image.count} images"
puts "   - #{Bid.count} bids"
