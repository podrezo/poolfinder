require 'sqlite3'

# Represents the database for activities that are extracted from the parser
class ActivitiesDatabase
  attr_reader :db
  def initialize(sqlite_db)
    @db = sqlite_db
    # TODO: Clear existing entries, maybe drop table?
    @db.execute 'CREATE TABLE IF NOT EXISTS
                 activities(id INTEGER PRIMARY KEY, location_id INTEGER,
                 name TEXT, dt_from TEXT, dt_to TEXT)'
  end

  # schedule is an instance of the Schedule class from the parser
  def load_schedule(schedule)
    schedule.locations.each do |location|
      q = @db.prepare 'SELECT id FROM locations WHERE name=? LIMIT 1'
      q.bind_param(1, location.name)
      #current_location_id = db.last_insert_row_id
      load_activities(q.execute.next[0], location.activities)
    end
  end

  def load_activities(location_id, activities)
    activities.each do |activity|
      # sqlite3 has no datetime type, it stores time as text in the format
      # YYYY-MM-DD HH:MM:SS.SSS
      # we convert from our ruby DateTime to that format for storage
      dt_from = activity.dt_from.format('%F %R%S.%L')
      dt_to = activity.dt_to.format('%F %R%S.%L')
      @db.execute "INSERT INTO activities(location_id, name, dt_from, dt_to)
                   VALUES(#{location_id}, '#{activity.name}',
                   '#{dt_from}','#{dt_to}')"
    end
  end
end
