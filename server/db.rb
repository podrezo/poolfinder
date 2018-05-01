require 'sqlite3'
require_relative 'constants'

# Represents the database for activities that are extracted from the parser
class ActivitiesDatabase
  attr_reader :db
  def initialize(sqlite_db)
    @db = sqlite_db
    # TODO: Clear existing entries, maybe drop table?
    @db.execute 'CREATE TABLE IF NOT EXISTS
                 activities(id INTEGER PRIMARY KEY, location_id INTEGER,
                 name TEXT, dt_from TEXT, dt_to TEXT)'
    
    # Load location data into memory for fast lookups
    @location_id_map = {}
    @location_name_map = {}
    q = @db.prepare 'SELECT id,name,longitude,latitude,address FROM locations'
    result = q.execute
    result.each do |row|
      @location_id_map[row[0]] = row[1]
      @location_name_map[row[1]] = row[0]
    end
  end

  # schedule is an instance of the Schedule class from the parser
  def load_schedule(schedule)
    schedule.locations.each do |location|
      # Find the foreign key for the location
      # q = @db.prepare 'SELECT id FROM locations WHERE name=? LIMIT 1'
      # q.bind_param(1, location.name)
      #current_location_id = db.last_insert_row_id
      get_location_by_id()
      load_activities(q.execute.next[0], location.activities)
    end
  end

  def get_location_by_id(location_id)
    @location_id_map[location_id]
  end
  def get_location_by_name(location_name)
    @location_name_map[location_name]
  end

  # Load an activity into the database
  def load_activities(location_id, activities)
    activities.each do |activity|
      # sqlite3 has no datetime type, it stores time as text in the format
      # YYYY-MM-DD HH:MM:SS.SSS
      # we convert from our ruby DateTime to that format in storage
      dt_from = activity.dt_from.strftime(SQLITE_DATE_FORMAT)
      dt_to = activity.dt_to.strftime(SQLITE_DATE_FORMAT)
      @db.execute "INSERT INTO activities(location_id, name, dt_from, dt_to)
                   VALUES(#{location_id}, '#{activity.name}',
                   '#{dt_from}','#{dt_to}')"
    end
  end
end
