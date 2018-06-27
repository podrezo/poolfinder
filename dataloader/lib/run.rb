require 'csv'
# require_relative 'firebase'
require_relative 'location_parser'
require_relative 'schedule_parser'

# firestore = PoolfinderFirestore.new

location_columns = [
  :id, :name, :category, :address, :phone, :latitude, :longitude
]
csv_string = CSV.open('../tmp/pools.csv', 'w') do |csv|
  csv << location_columns.map { |c| c.to_s }
  LocationParser.parse('../static_data/pools.xml').each do |pool|
    # puts "Processing location '#{:name]}'"
    # firestore.create_or_update_location(pool)
    csv << location_columns.map { |c| pool[c] }
  end
end

# ScheduleParser.parse_swim_times('dataloader/static_data/leisure-drop-in.html').each_with_index do |swim_time, i|
#   puts "Processing swim time #{i + 1} of #{swim_times.size}"
#   firestore.create_or_update_schedule(swim_time)
# end
