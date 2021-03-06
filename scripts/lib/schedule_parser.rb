require 'rubygems'
require 'time'
require 'date'
require 'nokogiri'
require 'open-uri'

# Parses a given URL into a schedule dictionary
class ScheduleParser
  LOCATION = '.pfrProgramDescrList .pfrListing'
  WEEK = 'table tbody tr'
  HOURS_CELL = 'td'
  HOURS_TEXT_SEPARATOR = '<br>'

  DAY = 60 * 60 * 24

  TIME_RANGE_REGEXP = /(\d{1,2})(:(\d{1,2}))?(am|pm)? - (\d{1,2})(:(\d{1,2}))?(am|pm)?/

  # To understand how this parser works, it is helpful to look at the source
  # HTML page in your browser. Basically the HTML is structured as follows:
  #
  # List of locations (Root)
  # |
  # +- Location (e.g. Agincourt Recreation Centre)
  #    |
  #    +- Activity + Week (e.g. "Leisure Swim" and "Jun 17 to Jun 23")
  #       |
  #       +- Day of the week (e.g. Monday)
  #          |
  #          +- List of times (e.g. 2 - 5pm, 5:30 - 9pm)
  #             |
  #             +- Specific time span (e.g. 2 - 5pm)

  def self.parse_swim_times(url)
    Nokogiri::HTML(open(url)).css(LOCATION).flat_map do |location_html|
      validate_table_heading(location_html)
      location_html.css(WEEK).flat_map do |week_html|
        week_html.css(HOURS_CELL)[1..-1].map.with_index
          .select { |hours_cell_html, wday| has_swim_times?(hours_cell_html) }
          .flat_map do |hours_cell_html, wday|
            hours_cell_html.inner_html.split(HOURS_TEXT_SEPARATOR).map do |hours_text|
              from, to = parse_range(week_start(week_html), wday, hours_text)
              validate_matching_day_of_week(hours_cell_html, from)

              {
                location_id: location_id(location_html),
                activity: activity_name(week_html),
                from: from,
                to: to,
              }
            end
          end
      end
    end
  end

  def self.has_swim_times?(hours_cell_html)
    # Some days don't have swim times, we want to skip those days
    hours_text = hours_cell_html.text.strip
    hours_text.length > 1
  end

  def self.week_start(week_html)
    activity_name = activity_name(week_html)
    date_range = week_html.css('td').first.css('strong')[1].text.strip
    week_dates = date_range.split(' to ')
    week_dates.first
  end

  def self.parse_range(date, offset_days, times)
    from_time, to_time = normalize_times(times)

    [
      Time.parse("#{date} #{from_time}") + offset_days * DAY,
      Time.parse("#{date} #{to_time}") + offset_days * DAY
    ]
  end

  # Take a time range string and convert it to an array of two normalized times
  # Example: normalize_times('6-8pm') # oututs ['6:00pm', '8:00pm']
  def self.normalize_times(time_range)
    regexp_match = TIME_RANGE_REGEXP.match(time_range)
    raise "input string '#{time_range}' is not in correct format" if regexp_match.nil?
    from_hr = regexp_match[1]
    from_min = regexp_match[3] || '00'
    from_ampm = regexp_match[4]
    to_hr = regexp_match[5]
    to_min = regexp_match[7] || '00'
    to_ampm = regexp_match[8]

    from_ampm ||= to_ampm
    to_ampm ||= from_ampm

    ["#{from_hr}:#{from_min}#{from_ampm}", "#{to_hr}:#{to_min}#{to_ampm}"]
  end

  def self.location_id(location_html)
    location_html.attr('data-id').to_i
  end

  def self.location_name(location_html)
    location_html.css('h2 a').text
  end

  def self.activity_name(week_html)
    week_html.css('td div').text.strip
  end

  def self.validate_table_heading(location_html)
    table_header = location_html.css('table thead tr th').text.strip

    if table_header != 'Program  Sun  Mon  Tue  Wed  Thu  Fri  Sat'
      raise "Unexpected table heading '#{table_header}'"
    end
  end

  def self.validate_matching_day_of_week(hours_cell_html, from)
    day_of_the_week_attr = hours_cell_html.attr('data-info')

    if from.strftime('%a') != day_of_the_week_attr
      raise "Unexpected day of the week '#{from.strftime('%a')}' doesn't match '#{day_of_the_week_attr}'"
    end
  end
end
