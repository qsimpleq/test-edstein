require "rails_helper"

describe WeatherAPI, type: :request do
  def json_sym(json) = JSON.parse(json).symbolize_keys

  it "Get current temperature" do
    get "/weather/current"

    expect(response).to have_http_status(:success)

    weather = JSON.parse(response.body).symbolize_keys
    expect(weather[:timestamp]).eql? "2023-12-26T15:41:00.000Z"
    expect(weather[:temperature].to_d).eql?(-2.2.to_d)
  end

  describe "last 24 hours historical info" do
    let(:stat) { city_weather_stats(:moscow) }

    it "Get hourly temperature" do
      get "/weather/historical"

      expect(response).to have_http_status(:success)

      weathers = JSON.parse(response.body)
      expect(weathers.size).eql?(24)
    end

    it "Get avg temperature" do
      get "/weather/historical/avg"

      expect(response).to have_http_status(:success)

      weather = json_sym(response.body)
      expect(weather[:temperature]).eql?(stat.avg_temperature)
    end

    it "Get max temperature" do
      get "/weather/historical/max"

      expect(response).to have_http_status(:success)
      weather = json_sym(response.body)
      expect(weather[:temperature]).eql?(stat.max_temperature)
    end

    it "Get min temperature" do
      get "/weather/historical/min"

      expect(response).to have_http_status(:success)
      weather = json_sym(response.body)
      expect(weather[:temperature]).eql?(stat.min_temperature)
    end

    it "Can't find temperature by nearest timestamp" do
      get "/weather/historical/by_time?timestamp=123"

      expect(response).to have_http_status(:not_found)
    end

    it "Find temperature by nearest timestamp" do
      weather = city_weathers(:w2)
      timestamp = weather.timestamp

      [timestamp, timestamp - 20, timestamp + 20].map do |t|
        get "/weather/historical/by_time?timestamp=#{t.to_i}"

        expect(response).to have_http_status(:success)
        expect(json_sym(response.body)[:temperature]).eql?(weather.temperature)
      end
    end
  end
end
