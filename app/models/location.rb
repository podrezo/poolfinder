class Location < ApplicationRecord
  has_many :schedule, dependent: :destroy
  scope :within, -> (latitude, longitude, distance_in_meters = 10000) {
    where(%{
     ST_Distance(coordinates, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_meters])
  }
end
