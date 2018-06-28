require 'csv'
require 'logger'
require_relative 'firebase'
require_relative 'location_parser'
require_relative 'schedule_parser'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

firestore = PoolfinderFirestore.new

all_location_ids = nil
location_columns = [
  :id, :name, :category, :address, :phone, :latitude, :longitude
]
CSV.open('../static_data/pools.csv', 'w') do |csv|
  csv << location_columns.map(&:to_s)
  all_location_ids = LocationParser.parse('../static_data/pools.xml').map do |pool|
    puts "Processing location '#{pool[:name]}'"
    firestore.create_or_update_location(pool)
    csv << location_columns.map { |c| pool[c] }
    pool[:id]
  end
end

schedule_urls_to_scrape = [
  'https://www.toronto.ca/data/parks/prd/swimming/dropin/leisure/index.html',
  'https://www.toronto.ca/data/parks/prd/swimming/dropin/family/index.html',
  'https://www.toronto.ca/data/parks/prd/swimming/dropin/female/index.html',
  'https://www.toronto.ca/data/parks/prd/swimming/dropin/lane/index.html'

]
schedule_columns = [
  :from, :to, :location_id, :activity
]
# Track locations we don't have loaded
non_existant_locations = []
CSV.open('../static_data/schedule.csv', 'w') do |csv|
  csv << schedule_columns.map(&:to_s)
  schedule_urls_to_scrape.each do |url|
    logger.info("Scraping url \"#{url}\"...")
    ScheduleParser.parse_swim_times(url).each_with_index do |swim_time, i|
      logger.info("Processing swim time #{i + 1}") if (i % 100).zero?
      firestore.create_or_update_schedule(swim_time)
      if !all_location_ids.include?(swim_time[:location_id]) && !non_existant_locations.include?(swim_time[:location_id])
        logger.warn("Location with ID [#{swim_time[:location_id]}] not in locations list")
        non_existant_locations.push(swim_time[:location_id])
      end
      csv << schedule_columns.map { |c| swim_time[c].to_s }
    end
  end
end