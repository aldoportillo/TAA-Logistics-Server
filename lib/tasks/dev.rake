namespace :db do
  desc "Load sample data into the database"
  task load_sample_data: :environment do
    # Create sample users
    User.create!(
      email: 'ed@taalogistics.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'Ed',
      role: 'admin',
      phone_number: '+11234567890' # Valid US phone number format
    )

    User.create!(
      email: 'user1@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'User One',
      role: 'user',
      phone_number: '+11234567891' # Valid US phone number format
    )

    User.create!(
      email: 'user2@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'User Two',
      role: 'user',
      phone_number: '+11234567892' # Valid US phone number format
    )

    # Add more sample data for other tables as needed
    # Example for applications table
    Application.create!(
      first_name: 'John',
      last_name: 'Doe',
      address: '123 Main St',
      city: 'Anytown',
      state: 'CA',
      zip: '12345',
      birthday: '1980-01-01',
      ssn: '123-45-6789',
      phone_number: '+11234567890', # Valid US phone number format
      email: 'john.doe@example.com'
    )

    puts "Sample data loaded successfully."
  end
end