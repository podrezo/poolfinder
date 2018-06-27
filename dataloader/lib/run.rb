require 'csv'
# require_relative 'firebase'
require_relative 'location_parser'
require_relative 'schedule_parser'

# firestore = PoolfinderFirestore.new

all_location_ids = nil
location_columns = [
  :id, :name, :category, :address, :phone, :latitude, :longitude
]
CSV.open('../tmp/pools.csv', 'w') do |csv|
  csv << location_columns.map(&:to_s)
  all_location_ids = LocationParser.parse('../static_data/pools.xml').map do |pool|
    # puts "Processing location '#{:name]}'"
    # firestore.create_or_update_location(pool)
    csv << location_columns.map { |c| pool[c] }
    pool[:id]
  end
end

schedule_columns = [
  :from, :to, :location_id, :activity
]
CSV.open('../tmp/schedule.csv', 'w') do |csv|
  csv << schedule_columns.map(&:to_s)
  ScheduleParser.parse_swim_times('../static_data/leisure-drop-in.html').each_with_index do |swim_time, i|
    # puts "Processing swim time #{i + 1} of #{swim_times.size}"
    # firestore.create_or_update_schedule(swim_time)
    puts "Pool with id [#{swim_time[:location_id]}] not in locations list" unless all_location_ids.include?(swim_time[:location_id])
    csv << schedule_columns.map { |c| swim_time[c].to_s }
  end
end