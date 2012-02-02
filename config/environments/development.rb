EkBilling::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  config.serve_static_assets = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.dependency_loading = true  #if $rails_rake_task

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  email_settings = YAML::load(File.open("#{Rails.root}/config/smtp.yml"))
  config.action_mailer.smtp_settings = email_settings[Rails.env]

  yml = YAML::load(File.open("#{Rails.root}/config/authorize_net.yml"))
  AUTHORIZE_NET_CONFIG = yml['development']
  #AUTHORIZE_NET_CONFIG.merge!(yml[Rails.env]) unless yml[Rails.env].nil?
  #AUTHORIZE_NET_CONFIG.freeze

end

