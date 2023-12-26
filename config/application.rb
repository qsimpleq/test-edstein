require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
envfile = if ENV["RAILS_ENV"] == "production"
            File.join(Dir.pwd, ".env")
          else
            File.join(Dir.pwd, ".env.#{(ENV['RAILS_ENV'] || 'development').downcase}")
          end
Dotenv.load(envfile) if File.exist?(envfile)

module Weather
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"] }

    config.active_job.queue_adapter = :delayed_job

    config.autoload_paths << Rails.root.join("app/api")
    config.autoload_paths << Rails.root.join("app/services")

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.after_initialize do
      # pp ActiveRecord::Base&.connection
      # if ActiveRecord::Base&.connection&.tables&.include?("cities")
      #
      #   scheduler = Rufus::Scheduler.new
      #   city = City.first
      #
      #   AccuweatherAPIJob.perform_later(:hourly_temperature, city) unless CityWeather.any?
      #   AccuweatherAPIJob.perform_later(:current_temperature, city) unless CityCurrentWeather.any?
      #
      #   scheduler.every "10m" do
      #     AccuweatherAPIJob.perform_later(:hourly_temperature, city)
      #   end
      #
      #   scheduler.every "1h" do
      #     AccuweatherAPIJob.perform_later(:current_temperature, city)
      #   end
      # end
    end
  end
end
