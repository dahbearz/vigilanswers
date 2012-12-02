class Location < ActiveRecord::Base
  has_many :reports
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  attr_accessible :latitude, :longitude, :address
  
  validates_presence_of :address
  after_validation :geocode, :reverse_geocode, :if => lambda{ |obj| obj.address_changed?}
end
