Meetingup::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load
  config.active_record.default_timezone = :utc

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  Paperclip.options[:command_path] = "/usr/bin/"

  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  #config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => 'meetingupentropy@gmail.com',
    :password             => '123entropy',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

 #  ActionMailer::Base.smtp_settings = {
 #    :port =>           '587',
 #    :address =>        'smtp.mandrillapp.com',
 #    :user_name =>      'idel.the@gmail.com',
 #    :password =>       'idelvane123456',
 #    :domain =>         'vikstar.com.br',
 #    :authentication => :plain
 # }
 # ActionMailer::Base.delivery_method = :smtp
 
 #  config.action_mailer.smtp_settings = {
 #   :address              => "smtp.vikstar.com.br",
 #   :port                 => 587,
 #   :domain               => 'vikstar.com.br',
 #   :user_name            => 'no-reply@vikstar.com.br',
 #   :password             => 'vikstar.2014',
 #   :authentication       => 'plain',
 #   :enable_starttls_auto => true
 # }

  STDOUT.sync =true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
 
end
