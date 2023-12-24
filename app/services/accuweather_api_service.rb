require "faraday"
require "json"

class AccuweatherAPIService
  API_KEY = ENV["APIKEY_ACCUWEATHER"].freeze
  API_URL = "https://dataservice.accuweather.com/currentconditions/v1".freeze
  API_KEY_PARAMS = "apikey=#{API_KEY}".freeze

  def self.current_temperature(location)
    response = Faraday.get("#{API_URL}/#{location}?#{API_KEY_PARAMS}")
    JSON.parse(response.body).first["Temperature"]["Metric"]["Value"]
  end

  def self.hourly_temperature(location)
    response = Faraday.get("#{API_URL}/#{location}/historical/24?#{API_KEY_PARAMS}")
    JSON.parse(response.body).map do |data|
      [data["EpochTime"], data["Temperature"]["Metric"]["Value"]]
    end.to_h
  end
end
