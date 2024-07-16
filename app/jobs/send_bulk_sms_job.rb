class SendBulkSmsJob
  include Sidekiq::Job

  def perform(message, driver_ids)
    drivers = User.where(id: driver_ids, role: 'driver')
    drivers.each do |driver|
      # Replace this with your SMS service logic
      SmsService.send_sms(driver.phone_number, message)
    end
  end
end
