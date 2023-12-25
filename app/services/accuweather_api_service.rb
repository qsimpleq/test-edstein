class AccuweatherAPIService
  API_KEY = ENV["APIKEY_ACCUWEATHER"].freeze
  API_URL = "https://dataservice.accuweather.com/currentconditions/v1".freeze
  API_KEY_PARAMS = "apikey=#{API_KEY}".freeze

  def self.current_temperature(city)
    response = Faraday.get("#{API_URL}/#{city.location}?#{API_KEY_PARAMS}")
    data = JSON.parse(response.body).first

    result = prepare_weather(city, data)

    current = city.city_current_weather || CityCurrentWeather.new(result)
    current.update(result)

    current
  end

  def self.hourly_temperature(city)
    response = Faraday.get("#{API_URL}/#{city.location}/historical/24?details=true&#{API_KEY_PARAMS}")
    parsed_data = JSON.parse(response.body)

    weathers = parsed_data.map { prepare_weather(city, _1) }
    stats = prepare_weather_stats(city, parsed_data)

    ActiveRecord::Base.transaction do
      stat = city.city_weather_stat || CityWeatherStat.new(stats)
      stat.update(stats)

      weathers.reverse_each do |w|
        next if CityWeather.find_by(city_id: w[:city_id], timestamp: w[:timestamp])

        CityWeather.create(w)
      end
    end
  end

  def self.prepare_weather(city, data)
    {
      city_id: city.id,
      timestamp: Time.zone.parse(data["LocalObservationDateTime"]).to_datetime,
      temperature: data["Temperature"]["Metric"]["Value"]
    }
  end

  def self.prepare_weather_stats(city, data)
    range = data.first["TemperatureSummary"]["Past24HourRange"]
    avg = data.reduce(0) { |sum, n| sum + n["Temperature"]["Metric"]["Value"] } / data.size

    {
      city_id: city.id,
      max_temperature: range["Maximum"]["Metric"]["Value"],
      min_temperature: range["Minimum"]["Metric"]["Value"],
      avg_temperature: avg
    }
  end
end
