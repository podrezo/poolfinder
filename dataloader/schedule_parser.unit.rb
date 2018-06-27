require_relative 'schedule_parser'
require 'test/unit'

# Unit tests for the parser
class TestParser < Test::Unit::TestCase
  # def test_invalid_input
  #     assert_raise "input string 'This is invalid' is not in correct format" do
  #         parse_hours('This is invalid')
  #     end
  #     assert_raise  "input string '6:30 – 8pm' is not in correct format" do
  #         parse_hours('6:30 – 8pm') # &ndash;
  #     end
  #     assert_raise 'Must have at least one am/pm designator' do
  #         parse_hours('6 - 8')
  #     end
  #     assert_raise 'am/pm designator cannot come first' do
  #         parse_hours('6am - 8')
  #     end
  # end

  def test_simple
    from, to = ScheduleParser.parse_range('Apr 22', 0, '6:30 - 8pm')

    assert_equal '2018-04-22T18:30', from.to_s[0, 16]
    assert_equal '2018-04-22T20:00', to.to_s[0, 16]
  end

  def test_normalize_times_invalid
    assert_raise "input string 'This is invalid' is not in correct format" do
      ScheduleParser.normalize_times('This is invalid')
    end
  end

  def test_normalize_times_simple
    assert_equal(
      ['6:00pm', '8:00pm'],
      ScheduleParser.normalize_times('6 - 8pm')
    )
    assert_equal(
      ['6:30pm', '8:00pm'],
      ScheduleParser.normalize_times('6:30 - 8pm')
    )
    assert_equal(
      ['6:14pm', '8:45pm'],
      ScheduleParser.normalize_times('6:14pm - 8:45pm')
    )
    assert_equal(
      ['6:00am', '8:00am'],
      ScheduleParser.normalize_times('6am - 8')
    )
    assert_equal(
      ['6:15pm', '8:35pm'],
      ScheduleParser.normalize_times('6:15 - 8:35pm')
    )
    assert_equal(
      ['12:00pm', '2:00pm'],
      ScheduleParser.normalize_times('12 - 2pm')
    )
  end
end
