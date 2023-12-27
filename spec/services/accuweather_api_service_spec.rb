require "rails_helper"

describe AccuweatherAPIService, vcr: true do
  let(:service) { described_class }
  let(:city) { cities(:moscow) }

  describe ".current_temperature" do
    let(:current_weather) { city_current_weathers(:moscow) }

    it "retrieves the current forecast for a given city and create" do
      VCR.use_cassette("city_current_weather") do
        CityCurrentWeather.delete_all

        forecast = service.current_temperature(city)

        expect(forecast).to be_a(CityCurrentWeather)
        expect(forecast).to be_persisted
      end
    end

    it "retrieves the current forecast for a given city and update" do
      VCR.use_cassette("city_current_weather") do
        forecast = service.current_temperature(city)

        expect(forecast).to be_a(CityCurrentWeather)
        expect(forecast.timestamp).eql? DateTime.parse("Tue, 26 Dec 2023 15:42:00.000000000 UTC +00:00")
        expect(forecast.temperature.to_d).eql?(-2.2.to_d)
      end
    end
  end

  describe ".hourly_temperature" do
    it "retrieves the last 24 hours forecasts for a given city" do
      VCR.use_cassette("city_weather") do
        CityWeather.delete_all

        forecasts = service.hourly_temperature(city)

        expect(forecasts).to be_a(Array)
        expect(forecasts.size).to be 24
      end
    end
  end
end
