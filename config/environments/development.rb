EkBilling::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

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

  config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "gmail.com",
      :user_name            => "lowerhopewellfarm", #Your user name
      :password             => "bristolbay1", # Your password
      :authentication       => "plain",
      :enable_starttls_auto => true
  }

  #config.action_mailer.sendmail_settings = {
  #    :location => '/usr/sbin/sendmail',
  #    :arguments => '-i -t'
  #}

end

