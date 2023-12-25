class AccuweatherAPIJob < ApplicationJob
  queue_as :default

  def perform(action, city)
    case action
    when :current_temperature
      service.current_temperature(city)
    when :hourly_temperature
      service.hourly_temperature(city)
    end
  end

  private

  def service
    AccuweatherAPIService
  end
end
