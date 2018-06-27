require 'test/unit'
require_relative '../lib/location_parser'

class LocationParserTest < Test::Unit::TestCase
  def test_parse
    expected_location = {
      address: '19 Castlegrove Blvd',
      category: 'Outdoor Pool',
      coordinates: { latitude: 43.745989, longitude: -79.322827 },
      intersection: '',
      name: 'Broadlands Community Centre',
      phone: '416-395-7966'
    }

    result = LocationParser.parse('../static_data/pools.xml')

    assert_equal 121, result.size
    assert_equal expected_location, result.first
  end
end
