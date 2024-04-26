class TwilioService
    def initialize
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
    end
  
    def send_mass_sms(body, phone_numbers)
      phone_numbers.each do |number|
        @client.messages.create(
          body: body,
          from: '+18664897353',
          to: number
        )
      end
    end
  end
  