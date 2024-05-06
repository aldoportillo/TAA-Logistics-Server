class TwilioService
  def initialize
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_mass_sms(body, phone_numbers)
    phone_numbers.each do |number|
      Rails.logger.info "Sending SMS to #{number} from #{ENV['TWILIO_PHONE_NUMBER']}: #{body}"
      begin
        message = @client.messages.create(
          body: body,
          from: ENV['TWILIO_PHONE_NUMBER'], 
          to: number
        )
        Rails.logger.info "Message sent to #{number}: #{message.sid}"
      rescue Twilio::REST::RestError => e
        Rails.logger.error "Error sending message to #{number}: #{e.message}"
      end
    end
  end
end
