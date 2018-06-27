require 'google/cloud/firestore'
require 'digest'

class PoolfinderFirestore
  HASHER = Digest::SHA256

  def initialize
    @firestore = Google::Cloud::Firestore.new
    @locations_collection = @firestore.col('locations')
    @schedule_collection = @firestore.col('schedule')
  end

  def create_or_update_location(args)
    # The document ID is just a hash of the name to avoid data duplication
    hash = HASHER.hexdigest(args[:name])

    @locations_collection.doc(hash).set(args)
  end

  def create_or_update_schedule(args)
    # Use a hash of all four values
    hash = HASHER.hexdigest("#{args[:location_name]}:#{args[:activity_name]}:#{args[:from]}:#{args[:to]}")

    @schedule_collection.doc(hash).set(args)
  end
end
