class User < ActiveRecord::Base
  def self.carriers
    @@carriers ||= {
    :alltel => '@message.alltel.com',
    :att => '@txt.att.net',
    :boost_mobile => '@myboostmobile.com',
    :nextel => '@messaging.nextel.com',
    :sprint => '@messaging.sprintpcs.com',
    :tmobile => '@tmomail.net',
    :us_cellular => '@email.uscc.net',
    :verizon => '@vtext.com',
    :virgin_mobile => '@vmobl.com'
  }
end
  acts_as_authentic do |c|
    c.login_field = :username
  end
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  

  attr_accessible :username, :email, :password, :password_confirmation, :sms
  after_validation :geocode, :reverse_geocode, :if => lambda{ |obj| obj.address_changed? }
end
