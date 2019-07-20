module GeoFactory
  # Returns an instance of a geographic point; used for storing to DB model
  def self.point(latitude, longitude)
    factory = RGeo::Geographic.spherical_factory(:srid => 4326)
    factory.point(longitude, latitude)
  end
end
