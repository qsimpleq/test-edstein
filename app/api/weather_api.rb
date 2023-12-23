# app/api/weather_api.rb
class WeatherAPI < Grape::API
  format :json

  resource :weather do
    desc "Get current temperature"
    get :current do
      { status: "current" }
    end

    resource :historical do
      desc "Get hourly temperature for the last 24 hours"
      get "/" do
        { status: "historical" }
      end

      desc "Get avg temperature for the last 24 hours"
      get :avg do
        { status: "historical avg" }
      end

      resource :by_time do
        desc "Find temperature by nearest timestamp"
        params do
          requires :timestamp, type: Integer
        end
        post do
          { status: "historical by_time" }
        end
      end

      desc "Get max temperature for the last 24 hours"
      get :max do
        { status: "historical max" }
      end

      desc "Get min temperature for the last 24 hours"
      get :min do
        { status: "historical min" }
      end
    end
  end
end
