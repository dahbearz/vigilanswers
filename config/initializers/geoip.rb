module Vigilanswers
  GEODATA_LOCATION = Rails.root.join('config', 'geo_lite_city.dat')

  def self.geoip
    @@geoip ||= GeoIP.new(GEODATA_LOCATION)
  end
end
