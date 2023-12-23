class HealthAPI < Grape::API
  format :json

  resource :health do
    desc "Check backend status"
    get do
      { status: "OK" }
    end
  end
end
