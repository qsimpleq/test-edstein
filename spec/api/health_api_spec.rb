require "rails_helper"

describe HealthAPI, type: :request do
  describe "GET /health" do
    it "returns OK status" do
      get "/health"

      expect(response).to have_http_status(:success)
      expect(response.body).eql?({ "status" => "OK" })
    end
  end
end
