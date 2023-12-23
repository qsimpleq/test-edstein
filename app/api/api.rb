class API < Grape::API
  format :json
  mount HealthAPI
  mount WeatherAPI
  add_swagger_documentation doc_version: "0.0.1",
                            info: { title: "Weather info" }
end
