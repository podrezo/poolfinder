require 'rubygems'
require 'time'
require 'date'
require 'nokogiri'
require 'open-uri'

# Parses a given URL into a schedule dictionary
class ScheduleParser
  TIME_RANGE_REGEXP = /(\d{1,2})(:(\d{1,2}))?(am|pm)? - (\d{1,2})(:(\d{1,2}))?(am|pm)?/

  # The date-time format that's going to be supplied at the end
  # e.g. 'Apr 24 5:36pm', year is assumed to be current one
  STRPTIME_FORMAT_DATETIME = '%b %d %l:%M%P %z'.freeze

  # ASSUMED_TIMEZONE = 'America/New_York'.freeze
  # DEFAULT_DATETIME_OUTPUT_FORMAT = '%c %Z'.freeze
  # Toronto doesn't use timezones not on an even hour, otherwise we'd have a problem
  CURRENT_TIMEZONE = Time.now.getlocal.zone
  CURRENT_TIMEZONE_OFFSET_EASTERN = (Time.zone_offset(CURRENT_TIMEZONE) / 60 / 60)

  def self.parse_swim_times(url)
    parse(url).flat_map do |location|
      location[:activities].flat_map do |activity|
        activity[:hours].map do |hours|
          {
            from: hours[:from],
            to: hours[:to],
            activity_name: activity[:name],
            location_name: location[:location_name],
          }
        end
      end
    end
  end

  def self.parse(url)
    page = Nokogiri::HTML(open(url))
    parse_document(page)
  end

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

  def self.parse_document(page)
    listings = page.css('.pfrProgramDescrList .pfrListing')
    listings.map { |location_html|
      # Sanity check - does the table have the expected columns?
      table_header = location_html.css('table thead tr th').text.strip
      raise "Unexpected table heading '#{table_header}'" if table_header != 'Program  Sun  Mon  Tue  Wed  Thu  Fri  Sat'
      location_name = location_html.css('h2 a').text
      # Build result
      {
        location_name: location_name,
        activities: parse_weeks(location_html).flatten
      }
    }
  end

  def self.parse_weeks(location_html)
    weeks_html = location_html.css('table tbody tr')
    weeks_html.map do |week_html|
      activity_title = week_html.css('th div').text.strip
      row_title = week_html.css('th').text.strip
      week_dates =
        row_title[activity_title.length..row_title.length].strip.split(' to ')
      hours_cells_html = week_html.css('td')
      # There may be multiple hours for the same day, but we want a flat
      # array of times so we use flatten
      hours = parse_hours(hours_cells_html, week_dates[0]).flatten
      {
        name: activity_title,
        hours: hours
      }
    end
  end

  def self.parse_hours(hours_html, week_start)
    hours_html.each_with_index
      .select { |hours_cell_html, day_offset|
        # Some days don't have swim times, we want to skip those days
        hours_text = hours_cell_html.text.strip
        hours_text.length > 1
      }
      .map { |hours_cell_html, day_offset|
        # The index carries over from the select, luckily!
        # The cell can have multiple swim times in the same cell, separated by
        # new lines.
        # TODO: This probably shouldn't rely on splitting on an HTML tag...
        hours_texts = hours_cell_html.inner_html.split('<br>')
        hours_texts.map { |hours_text|
          range = parse_range(week_start, day_offset, hours_text)
          # Assert that we have the matching day of the week
          day_of_the_week_attr = hours_cell_html.attr('data-info')
          raise "Unexpected day of the week '#{range[0].strftime('%a')}' doesn't match '#{day_of_the_week_attr}'" if range[0].strftime('%a') != day_of_the_week_attr
          # Build result
          {
            from: range[0],
            to: range[1],
          }
        }
      }
  end

  # Take a time range string and convert it to an array of two normalized times
  # Example: normalize_times('6-8pm') # oututs ['6:00pm', '8:00pm']
  def self.normalize_times(time_range)
    regexp_match = TIME_RANGE_REGEXP.match(time_range)
    raise "input string '#{input}' is not in correct format" if regexp_match.nil?
    from_hr = regexp_match[1]
    from_min = regexp_match[3]
    from_min = '00' if from_min.nil?
    from_ampm = regexp_match[4]
    to_hr = regexp_match[5]
    to_min = regexp_match[7]
    to_min = '00' if to_min.nil?
    to_ampm = regexp_match[8]

    from_ampm = to_ampm if from_ampm.nil?
    to_ampm = from_ampm if to_ampm.nil?

    ["#{from_hr}:#{from_min}#{from_ampm}", "#{to_hr}:#{to_min}#{to_ampm}"]
  end

  def self.parse_range(date, offset_days, times)
    # Convert times into normalized values
    times = normalize_times(times)
    # Create a string to be parsed
    from_datetime = DateTime.strptime(
      "#{date} #{times[0]} #{CURRENT_TIMEZONE_OFFSET_EASTERN}", STRPTIME_FORMAT_DATETIME
    )
    to_datetime = DateTime.strptime(
      "#{date} #{times[1]} #{CURRENT_TIMEZONE_OFFSET_EASTERN}", STRPTIME_FORMAT_DATETIME
    )
    from_datetime = from_datetime.next_day(offset_days)
    to_datetime = to_datetime.next_day(offset_days)
    [from_datetime, to_datetime]
  end
end
