require_relative 'firebase'
require_relative 'location_parser'
require_relative 'schedule_parser'

firestore = PoolfinderFirestore.new

LocationParser.parse('dataloader/static_data/pools.xml').each do |pool|
  puts "Processing location '#{pool[:name]}'"
  firestore.create_or_update_location(pool)
end

swim_times = ScheduleParser.parse('dataloader/static_data/leisure-drop-in.html').flat_map do |location|
  location[:activities].flat_map do |activity|
    activity[:hours].map do |hours|
      {
        from: hours[:from],
        to: hours[:to],
        activity_name: activity[:name],
        location_name: location[:location_name],
      }
    end
  end
end

swim_times.each_with_index do |swim_time, i|
  puts "Processing swim time #{i + 1} of #{swim_times.size}"
  firestore.create_or_update_schedule(swim_time)
end
