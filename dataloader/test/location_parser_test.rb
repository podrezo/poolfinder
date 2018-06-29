require 'test/unit'
require_relative '../lib/location_parser'

class LocationParserTest < Test::Unit::TestCase
  def test_parse
    expected_location = {
      address: '2 Forty Second St',
      category: 'Splash/Spray Pad',
      id: 6,
      latitude: 43.58564323,
      longitude: -79.54407233,
      name: 'Marie Curtis Park',
      phone: ' '
     }

    result = LocationParser.parse('test_data/pools.xml')

    assert_equal 348, result.size
    assert_equal expected_location, result.first
  end
end
