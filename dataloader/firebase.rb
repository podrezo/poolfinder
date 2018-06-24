require 'google/cloud/firestore'
require 'digest'

HASHER = Digest::SHA256

class PoolfinderFirestore
  
  def initialize
    @_firestore = Google::Cloud::Firestore.new
    @_locations_collection = @_firestore.col('locations')
    @_schedule_collection = @_firestore.col('schedule')
  end

  def create_or_update_location(
    name: '',
    latitude: 0,
    longitude: 0,
    address: '',
    phone: '',
    category: ''
  )
    # The document ID is just a hash of the name to avoid data duplication
    @_locations_collection.doc(HASHER.hexdigest(name)).set({
      name: name,
      coordinates: {
        latitude: latitude,
        longitude: longitude
      },
      address: address,
      phone: phone,
      category: category,
    })
  end

  def create_or_update_schedule(
    location_name: '',
    activity_name: '',
    time_from: nil,
    time_to: nil
  )
    # Use a hash of all four values
    hash = HASHER.hexdigest("#{location_name}:#{activity_name}:#{time_from}:#{time_to}")
    @_schedule_collection.doc(hash).set({
      activity_name: activity_name,
      location_name: location_name,
      from: from,
      to: to,
    })
  end
end