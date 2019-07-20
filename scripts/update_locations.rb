require_relative 'lib/location_parser'
require_relative 'lib/geo_factory'

POOL_LOCATIONS_FILE = 'https://www.toronto.ca/data/parks/assets/xml/pools.xml'

locations = LocationParser.parse(POOL_LOCATIONS_FILE)

locations.each_with_index do |loc, i|
  puts "Processing ##{loc[:id]} '#{loc[:name]}'... #{i+1}/#{locations.length}"
  Location.create_with(
    id: loc[:id],
    name: loc[:name],
    address: loc[:address],
    category: loc[:category],
    phone: loc[:phone],
    coordinates: GeoFactory.point(loc[:latitude], loc[:longitude]),
  ).find_or_create_by(id: loc[:id])
end