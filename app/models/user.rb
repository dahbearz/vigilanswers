class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :username
  end
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude


  attr_accessible :username, :email, :password, :password_confirmation, :address
  after_validation :geocode, :reverse_geocode, :if => lambda{ |obj| obj.address_changed? }
end
