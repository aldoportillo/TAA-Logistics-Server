require 'net/http'
require 'json'

class GoogleMapsService
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json"
  GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @api_key = api_key
    @port_addresses = Port.where(active: true).pluck(:name, :address).to_h
    @distance_cache = {}
  end

  def fetch_distance(route_points)
    pp "Begin Fetch for route: #{route_points}"
    cache_key = route_points.join(" -> ")
    return @distance_cache[cache_key] if @distance_cache.key?(cache_key)

    waypoints = route_points[1..-2].map { |point| URI.encode_www_form_component(point) }.join('|')

    url = "#{BASE_URL}?origin=#{URI.encode_www_form_component(route_points.first)}" \
          "&destination=#{URI.encode_www_form_component(route_points.last)}" \
          "&waypoints=#{waypoints}" \
          "&key=#{@api_key}"

    begin
      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)

      if data['status'] == 'OK'
        route = data['routes'].first['legs']
        total_distance = route.sum { |leg| leg['distance']['value'] } / 1609.34
        formatted_distance = "#{total_distance.round(4)}"
        @distance_cache[cache_key] = { distance: formatted_distance }
        pp "Total Distance: #{formatted_distance}"
        return { distance: formatted_distance }
      else
        pp "Google Maps API Error: #{data['status']} - #{data['error_message']}"
        return { distance: "error" }
      end
    rescue StandardError => e
      pp "Network Error: #{e.message}"
      return { distance: "error" }
    end
  end

  def get_ramp_address(ramp_name)
    @port_addresses[ramp_name] || ramp_name
  end

  def validate_location(city, state)
    location_query = "#{city}, #{state}, USA"
    url = "#{GEOCODE_URL}?address=#{URI.encode_www_form_component(location_query)}&key=#{@api_key}"

    begin
      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)

      if data['status'] == 'OK'
        formatted_address = data['results'].first['formatted_address']
        pp "Validated location: #{formatted_address}"
        return formatted_address
      else
        pp "Geocoding API Error for #{city}, #{state}: #{data['status']} - #{data['error_message']}"
        return "#{city}, #{state}, USA"
      end
    rescue StandardError => e
      pp "Network Error during validation: #{e.message}"
      return "#{city}, #{state}, USA"
    end
  end
end
