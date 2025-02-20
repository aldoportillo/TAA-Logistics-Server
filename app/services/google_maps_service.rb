require 'net/http'
require 'json'

class GoogleMapsService
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json"

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @api_key = api_key
  end

  def fetch_distance_and_tolls(destination)
    pp "Begin Fetch for destination #{destination}"
    origin = "18949 Wolf Rd, Mokena, IL 60448"
    destination_query = URI.encode_www_form_component(destination)

    url = "#{BASE_URL}?origin=#{URI.encode_www_form_component(origin)}&destination=#{destination_query}&key=#{@api_key}"

    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)

    if data['status'] == 'OK'
      route = data['routes'].first['legs'].first
      distance = route['distance']['text'] # e.g., "25.3 mi"
      tolls = route['steps'].select { |step| step['html_instructions'].include?('toll') }.count
      pp "Distance: #{distance} - # of Tolls: #{tolls}"
      { distance: distance, tolls: tolls }
    else
      debugger
      pp "Error #{data[status]}"
      { error: data['status'] }
    end
  end
end
