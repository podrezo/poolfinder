require_relative 'firebase'
require_relative 'location_parser'
require_relative 'schedule_parser'

firestore = PoolfinderFirestore.new

LocationParser.parse.each do |pool|
  puts "Processing location '#{pool[:name]}'"
  firestore.create_or_update_location(
    name: pool[:name],
    latitude: pool[:coordinates][:latitude],
    longitude: pool[:coordinates][:longitude],
    address: pool[:address],
    phone: pool[:phone],
    category: pool[:category],
  )
end

swim_times = []
ScheduleParser.parse.each do |location|
  location_name = location[:location_name]
  location[:activities].each do |activity|
    activity_name = activity[:name]
    activity[:hours].each do |h|
      swim_times.push({
        from: h[:from],
        to: h[:to],
        activity_name: activity_name,
        location_name: location_name,
      })
    end
  end
end

swim_times.each_with_index do |st, i|
  puts "Processing swim time #{i+1} of #{swim_times.length}"  
  firestore.create_or_update_schedule(
    activity_name: st[:activity_name],
    location_name: st[:location_name],
    time_from: st[:from],
    time_to: st[:to],
  )
end
