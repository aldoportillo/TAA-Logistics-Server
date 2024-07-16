class ThreeCxService
    include HTTParty
    base_uri 'https://api.3cx.com'
  
    def initialize
      @headers = {
        "Authorization" => "Bearer #{ENV['THREE_CX_API_KEY']}",
        "Content-Type" => "application/json"
      }
    end
  
    def send_sms(phone_number, message)
      options = {
        body: { to: phone_number, message: message }.to_json,
        headers: @headers
      }
      self.class.post('/sms', options)
    end
  end
  