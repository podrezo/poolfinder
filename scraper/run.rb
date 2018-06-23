require 'logger'


module MyLogger
  LOGGER = Logger.new $stderr, level: Logger::INFO
  def logger
    LOGGER
  end
end

# Define a gRPC module-level logger method before grpc/logconfig.rb loads.
module GRPC
  extend MyLogger
end

# ---------


require 'google/cloud/firestore'
require 'yaml'
require_relative 'parser'

# schedule = InfoParser.parse_page_url('leisure-drop-in.html')
locations = YAML.load_file('static_data/locations.yml')

firestore = Google::Cloud::Firestore.new
locations_collection = firestore.col('locations')

locations.each do |location|
  # MyLogger.info("Processing location #{location['name']}")
  locations_collection.doc(location['unique_facility_id']).set({
    name: location['name'],
    coordinates: {
      latitude: location['latitude'],
      longitude: location['longitude']
    },
    address: location['address']
  })
end

# firestore.transaction do |tx|
#   new_population = tx.get(city).data[:population] + 1
#   tx.update(city, { population: new_population })
# end