# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Vigilanswers::Application.initialize!

#Mailer Stuffs (SendGrid)
Vigilanswers::Application.configure do 
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :user_name => "groopfly",
    :password => "baconbacon",
    :domain => "lit-ridge-7864.herokuapp.com",
    :address => "smtp.sendgrid.net",
    :port => 25,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
  config.action_mailer.raise_delivery_errors = true
end
