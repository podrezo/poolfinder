require_relative 'db'
require_relative 'parser'
require 'test/unit'
require 'sqlite3'

# Unit tests for the database
class TestActivitiesDatabase < Test::Unit::TestCase
  def setup
    @location1 = Location.new('Memorial Pool')
    @location2 = Location.new('Norseman Community Center')
    @test_schedule = Schedule.new
    @test_schedule.locations.push(@location1)
    @test_schedule.locations.push(@location2)
    @database = SQLite3::Database.new(':memory:')
    @database.execute 'CREATE TABLE IF NOT EXISTS
                    locations(id INTEGER PRIMARY KEY, name TEXT, longitude REAL,
                    latitude REAL, address TEXT)'
    @database.execute "INSERT INTO locations(name, longitude, latitude, address)
                 VALUES('#{@location1.name}', 1, 1, '123 Fake St.')"
    @database.execute "INSERT INTO locations(name, longitude, latitude, address)
                 VALUES('#{@location2.name}', 2, 2, '4 Something Lane')"
    @db = ActivitiesDatabase.new(@database)
    # The DB is already assumed to have the table for locations with data
  end

  def test_simple
    @db.load_schedule(@test_schedule)
    q = @db.db.prepare 'SELECT id, name FROM locations'
    result = q.execute
    row = result.next
    assert_equal(1, row[0])
    assert_equal('Memorial Pool', row[1])
  end

  def test_get_location_by_name
    @db.load_schedule(@test_schedule)
    result = @db.get_location_by_id(1)
    assert_equal('Memorial Pool', result)
  end
end
