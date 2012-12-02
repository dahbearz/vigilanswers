# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Vigilanswers::Application.initialize!

#Mailer Stuffs (SendGrid)
ActionMailer::Base.smtp_settings = {
  :user_name => "groopfly",
  :password => "baconbacon",
  :domain => "lit-ridge-7864.herokuapp.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain
}
ActionMailer::Base.delivery_method = :smtp
