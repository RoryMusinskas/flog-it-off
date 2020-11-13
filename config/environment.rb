# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: 'Rails.application.credentials.dig(:sendgrid, :api_key)',
  domain: 'flog-it-off.herokuapp.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
config.action_mailer.default_url_options = { host: 'flog-it-off.herokuapp.com', protocol: 'https' }
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
