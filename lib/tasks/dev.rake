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

    Application.create!(
      # --------------------
      # Personal Info
      # --------------------
      first_name: "John",
      middle_name: "A",
      last_name: "Doe",
      street: "123 Main St",
      city: "Anytown",
      state: "CA",
      zip: "90210",
      date_of_birth: Date.new(1990, 1, 15),
      ssn: "123-45-6789",
      phone: "555-123-4567",
      email: "john.doe@example.com",

      # --------------------
      # Residences
      # --------------------
      residence_1_street: "456 Oak St",
      residence_1_city: "Oldtown",
      residence_1_state: "CA",
      residence_1_zip: "90123",
      residence_1_duration: "2 years",

      residence_2_street: "789 Pine St",
      residence_2_city: "Newcity",
      residence_2_state: "NV",
      residence_2_zip: "89012",
      residence_2_duration: "3 years",

      residence_3_street: "321 Maple Ave",
      residence_3_city: "Nexttown",
      residence_3_state: "AZ",
      residence_3_zip: "85001",
      residence_3_duration: "1 year",

      # --------------------
      # License
      # --------------------
      license_state: "CA",
      license_number: "D1234567",
      license_type: "Class A",
      license_expiration_date: Date.today + 5.years,

      # --------------------
      # Convictions
      # --------------------
      conviction_1_date: Date.new(2015, 5, 10),
      conviction_1_violation: "Speeding",
      conviction_1_state: "CA",
      conviction_1_penalty: "Fine $200",

      conviction_2_date: Date.new(2016, 8, 22),
      conviction_2_violation: "Parking",
      conviction_2_state: "NV",
      conviction_2_penalty: "Fine $50",

      conviction_3_date: Date.new(2017, 11, 5),
      conviction_3_violation: "Red Light",
      conviction_3_state: "AZ",
      conviction_3_penalty: "Fine $150",

      # --------------------
      # Driving Experience
      # --------------------
      straight_truck_type: "Box Truck",
      straight_truck_from: Date.new(2018, 1, 1),
      straight_truck_to: Date.new(2019, 1, 1),
      straight_truck_miles: 10000,

      tractor_semi_type: "18-Wheeler",
      tractor_semi_from: Date.new(2019, 2, 1),
      tractor_semi_to: Date.new(2020, 2, 1),
      tractor_semi_miles: 20000,

      tractor_two_trailers_type: "Double Trailer",
      tractor_two_trailers_from: Date.new(2020, 3, 1),
      tractor_two_trailers_to: Date.new(2021, 3, 1),
      tractor_two_trailers_miles: 15000,

      other_equipment_type: "Flatbed",
      other_equipment_from: Date.new(2021, 4, 1),
      other_equipment_to: Date.new(2022, 4, 1),
      other_equipment_miles: 12000,

      # --------------------
      # Accidents
      # --------------------
      accident_1_date: Date.new(2018, 6, 10),
      accident_1_nature: "Rear-end",
      accident_1_fatalities: 0,
      accident_1_injuries: 1,
      accident_1_chemical_spill: false,

      accident_2_date: Date.new(2019, 7, 15),
      accident_2_nature: "Side-swipe",
      accident_2_fatalities: 0,
      accident_2_injuries: 0,
      accident_2_chemical_spill: false,

      accident_3_date: Date.new(2020, 8, 20),
      accident_3_nature: "Collision",
      accident_3_fatalities: 0,
      accident_3_injuries: 2,
      accident_3_chemical_spill: true,

      # --------------------
      # FMCSA Questions
      # --------------------
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

      # --------------------
      # Employers
      # --------------------
      employer_1_name: "Acme Trucking",
      employer_1_street: "100 Industrial Way",
      employer_1_city: "Metropolis",
      employer_1_state: "CA",
      employer_1_zip: "90211",
      employer_1_phone: "555-987-6543",
      employer_1_position: "Driver",
      employer_1_salary: "$50,000",
      employer_1_from: Date.new(2018, 1, 1),
      employer_1_to: Date.new(2019, 1, 1),
      employer_1_reason_for_leaving: "Better opportunity",
      employer_1_subject_to_fmcsa: true,
      employer_1_safety_sensitive: true,

      employer_2_name: "Beta Logistics",
      employer_2_street: "200 Commerce Blvd",
      employer_2_city: "Gotham",
      employer_2_state: "NV",
      employer_2_zip: "89013",
      employer_2_phone: "555-654-3210",
      employer_2_position: "Driver",
      employer_2_salary: "$55,000",
      employer_2_from: Date.new(2019, 2, 1),
      employer_2_to: Date.new(2020, 2, 1),
      employer_2_reason_for_leaving: "Relocation",
      employer_2_subject_to_fmcsa: true,
      employer_2_safety_sensitive: false,

      employer_3_name: "Gamma Freight",
      employer_3_street: "300 Shipping Ln",
      employer_3_city: "Star City",
      employer_3_state: "AZ",
      employer_3_zip: "85002",
      employer_3_phone: "555-321-0987",
      employer_3_position: "Driver",
      employer_3_salary: "$60,000",
      employer_3_from: Date.new(2020, 3, 1),
      employer_3_to: Date.new(2021, 3, 1),
      employer_3_reason_for_leaving: "Career growth",
      employer_3_subject_to_fmcsa: false,
      employer_3_safety_sensitive: false,

      # --------------------
      # Employment Gaps
      # --------------------
      gap_1_from: Date.new(2021, 4, 1),
      gap_1_to: Date.new(2021, 6, 1),
      gap_1_reason: "Medical leave",

      gap_2_from: Date.new(2021, 7, 1),
      gap_2_to: Date.new(2021, 8, 1),
      gap_2_reason: "Personal",

      # --------------------
      # Signature & Metadata
      # --------------------
      signature_full_name: "John A Doe",
      signature_timestamp: DateTime.now,
      submitted_at: DateTime.now,
      template_version: "v1",
      template_hash: "abc123",
      render_engine_version: "1.0",
      pdf_version: "1.0"
    )


    puts "Seeding complete!"

  end
end