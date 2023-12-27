require "rails_helper"

describe WeatherAPI, type: :request do
  it "returns current weather" do
    get "/weather/current"
    expect(response).to have_http_status(:success)
  end

  # other tests...
end
