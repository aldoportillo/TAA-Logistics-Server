class SendBulkSmsJob
    include Sidekiq::Job
  
    def perform(message, phone_numbers)
      service = ThreeCxService.new
      phone_numbers.each do |number|
        response = service.send_sms(number, message)
        Rails.logger.info "Sent SMS to #{number}: #{response.body}"
      end
    end
  end
  