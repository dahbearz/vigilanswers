class AlertMailer < ActionMailer::Base
  default from: "alerts@vigilanswers.com"

  def alert_email(report)
      @report = report
      coords = {:longitude => report.latitude, :latitude => report.longitude}
      #@url  = "http://example.com/login"
      mail(:to => nearby_users.all.map(&:email), :subject => "Vigilanswers Alert", :template_path => 'alert_mailer', :template_name => 'alert') if nearby_users
    end
end
