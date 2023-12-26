require "rails_helper"

describe HealthAPI, type: :request do
  describe "GET /health" do
    it "returns OK status" do
      get "/health"

      assert response.ok?
      assert_equal({ "status" => "OK" }, JSON.parse(response.body))
    end
  end
end
