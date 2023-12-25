class WeatherAPI < Grape::API
  format :json

  helpers do
    def city
      @city ||= City.first
    end
  end

  resource :weather do
    desc "Get current temperature"
    get :current do
      city.city_current_weather
    end

    resource :historical do
      desc "Get hourly temperature for the last 24 hours"
      get "/" do
        city.city_weathers.order(timestamp: :desc).limit(24)
      end

      desc "Get avg temperature for the last 24 hours"
      get :avg do
        { avg_temperature: city.city_weather_stat.avg_temperature }
      end

      resource :by_time do
        desc "Find temperature by nearest timestamp"
        params do
          requires :timestamp, type: Integer
        end

        get do
          dt = Time.at(params[:timestamp]).utc.to_datetime
          lesser = city.city_weathers.where(timestamp: (dt - 1.hour)..dt).order(timestamp: :desc).limit(1)&.first
          greater = city.city_weathers.where(timestamp: dt..(dt + 1.hour)).order(timestamp: :asc).limit(1)&.first

          error! "Can't find such temperature", 404 if lesser.nil? && greater.nil?

          weather = if lesser.nil?
                      greater
                    elsif greater.nil?
                      lesser
                    elsif (lesser.timestamp - dt).abs < (greater.timestamp - dt).abs
                      lesser
                    else
                      greater
                    end

          { temperature: weather.temperature }
        end
      end

      desc "Get max temperature for the last 24 hours"
      get :max do
        { max_temperature: city.city_weather_stat.max_temperature }
      end

      desc "Get min temperature for the last 24 hours"
      get :min do
        { min_temperature: city.city_weather_stat.min_temperature }
      end
    end
  end
end
