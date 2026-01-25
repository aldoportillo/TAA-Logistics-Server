namespace :db do
  desc "Load sample data into the database"
  task load_sample_data: :environment do
    puts "Seeding database..."

    # -----------------------
    # USERS
    # -----------------------
    admin = User.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password",
      name: "Admin User",
      role: "admin",
      phone_number: "555-111-2222"
    )

    user = User.create!(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      name: "Regular User",
      role: "user",
      phone_number: "555-333-4444"
    )

    # -----------------------
    # EVENTS & IMAGES
    # -----------------------
    event = Event.create!(
      name: "Port Expansion Announcement",
      description: "Announcement regarding new port expansion plans."
    )

    Image.create!(
      event: event,
      url: "https://via.placeholder.com/800x600.png?text=Event+Image"
    )

    # -----------------------
    # PORTS
    # -----------------------
    Port.create!([
      {
        name: "Port of Los Angeles",
        address: "425 S Palos Verdes St, San Pedro, CA",
        active: true
      },
      {
        name: "Port of Long Beach",
        address: "415 W Ocean Blvd, Long Beach, CA",
        active: true
      }
    ])

    # -----------------------
    # PRICING MATRICES
    # -----------------------
    PricingMatrix.create!([
      {
        start_miles: 0,
        end_miles: 100,
        line_haul: 350.00,
        line_haul_plus_29_5_fuel_surcharge: 453.25
      },
      {
        start_miles: 101,
        end_miles: 300,
        line_haul: 750.00,
        line_haul_plus_29_5_fuel_surcharge: 971.25
      }
    ])

    # -----------------------
    # QUOTES
    # -----------------------
    Quote.create!(
      company_name: "Acme Logistics",
      contact_name: "Jane Smith",
      email: "jane@acmelogistics.com",
      phone: "555-777-8888",
      fax: "555-777-9999",
      commodity: "Frozen Produce",
      commodity_temp: -5,
      commodity_gross_weight: 42000,
      from: "Los Angeles, CA",
      destination: "Phoenix, AZ",
      shipping_date: Date.today + 2.days,
      delivery_date: Date.today + 5.days,
      shipping_zip_code: "90001",
      delivery_zip_code: "85001",
      container_size: "40ft",
      pallets: 22,
      equipment_type: "Reefer",
      rail_destination: "Phoenix Rail Yard",
      questions_or_notes: "Must maintain temperature at all times.",
      rate_per_mile: 3.25,
      miles: 380,
      line_haul: 1235.00,
      fuel_surcharge: 365.00,
      total: 1600.00,
      fsch_percent: 29.5,
      contacted: false,
      created_by_employee: true
    )

    # -----------------------
    # INQUIRIES
    # -----------------------
    Inquiry.create!(
      name: "Carlos Ramirez",
      phone_number: "555-999-0000",
      email_address: "carlos@example.com",
      message: "Looking for long-term freight solutions.",
      contacted: false
    )

    # -----------------------
    # BIDS
    # -----------------------
    Bid.create!
    Bid.create!

    # -----------------------
    # APPLICATION (BIG ONE)
    # -----------------------
    Application.create!(
      first_name: "Michael",
      middle_name: "A",
      last_name: "Johnson",
      street: "123 Main St",
      city: "Dallas",
      state: "TX",
      zip: "75201",
      date_of_birth: Date.new(1988, 4, 12),
      ssn: "123-45-6789",
      phone: "555-222-3333",
      email: "michael.johnson@example.com",

      residence_1_street: "123 Main St",
      residence_1_city: "Dallas",
      residence_1_state: "TX",
      residence_1_zip: "75201",
      residence_1_duration: "2019-2024",

      residence_2_street: "456 Oak Ave",
      residence_2_city: "Austin",
      residence_2_state: "TX",
      residence_2_zip: "78701",
      residence_2_duration: "2016-2019",

      license_state: "TX",
      license_number: "TX1234567",
      license_type: "CDL-A",
      license_expiration_date: Date.today + 3.years,

      conviction_1_date: Date.new(2018, 6, 1),
      conviction_1_violation: "Speeding",
      conviction_1_state: "TX",
      conviction_1_penalty: "Fine",

      accident_1_date: Date.new(2020, 9, 15),
      accident_1_nature: "Rear-end collision",
      accident_1_fatalities: 0,
      accident_1_injuries: 0,
      accident_1_chemical_spill: false,

      straight_truck_type: "Box Truck",
      straight_truck_from: Date.new(2019, 1, 1),
      straight_truck_to: Date.new(2021, 1, 1),
      straight_truck_miles: 120_000,

      tractor_semi_type: "Dry Van",
      tractor_semi_from: Date.new(2021, 1, 1),
      tractor_semi_to: Date.today,
      tractor_semi_miles: 220_000,

      currently_disqualified: false,
      license_suspended: false,
      license_denied: false,
      positive_drug_test_last_2_years: false,
      bac_over_point04: false,
      dui: false,
      refused_testing: false,
      controlled_substance_violation: false,
      drug_transport_possession: false,
      left_scene_of_accident: false,

      employer_1_name: "ABC Trucking",
      employer_1_city: "Dallas",
      employer_1_state: "TX",
      employer_1_phone: "555-444-5555",
      employer_1_position: "Driver",
      employer_1_salary: "$70,000",
      employer_1_from: Date.new(2021, 1, 1),
      employer_1_to: Date.today,
      employer_1_reason_for_leaving: "Seeking growth",
      employer_1_subject_to_fmcsa: true,
      employer_1_safety_sensitive: true,

      gap_1_from: Date.new(2016, 6, 1),
      gap_1_to: Date.new(2016, 12, 1),
      gap_1_reason: "Training",

      esign_consent: true,
      esign_consent_at: Time.current,
      esign_consent_text: "I consent to electronic signing.",
      signature_full_name: "Michael A Johnson",
      signature_method: "typed",
      signature_timestamp: Time.current,
      signing_ip_address: "192.168.1.100",
      signing_user_agent: "Mozilla/5.0",
      template_version: "v1.0",
      template_hash: "abc123hash",
      render_engine_version: "pdfkit-1.0",
      submitted_at: Time.current,
      pdf_version: "2026-01"
    )

    puts "Seeding complete!"

  end
end