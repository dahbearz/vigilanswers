class Location < ActiveRecord::Base

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  attr_accessible :lat, :long

  after_validation :geocode, :reverse_geocode, :if => lamda{ |obj| obj.address_changed?}
end
