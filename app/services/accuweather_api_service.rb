require "faraday"
require "json"

class AccuweatherAPIService
  API_KEY = ENV["APIKEY_ACCUWEATHER"].freeze
  API_URL = "https://dataservice.accuweather.com/currentconditions/v1".freeze
  API_KEY_PARAMS = "apikey=#{API_KEY}".freeze

  def self.current_temperature(location_key)
    response = Faraday.get("#{API_URL}/#{location_key}?#{API_KEY_PARAMS}")
    JSON.parse(response.body).first["Temperature"]["Metric"]["Value"]
  end

  def self.hourly_temperature(location_key)
    response = Faraday.get("#{API_URL}/#{location_key}/historical/24?#{API_KEY_PARAMS}")
    JSON.parse(response.body).map do |data|
      [Time.parse(data["LocalObservationDateTime"]).to_i, data["Temperature"]["Metric"]["Value"]]
    end.to_h
  end
end
