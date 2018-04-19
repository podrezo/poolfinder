require 'rubygems'
require 'date'
require 'nokogiri'
require 'open-uri'

# Parses a given URL into meaningful data chunks
class InfoParser
  TIME_RANGE_REGEXP =
    /(\d{1,2})(:(\d{1,2}))?(am|pm)? - (\d{1,2})(:(\d{1,2}))?(am|pm)?/
  # The date-time format that's going to be supplied at the end
  # e.g. 'Apr 24 5:36pm', year is assumed to be current one
  STRPTIME_FORMAT_DATETIME = '%b %d %l:%M%P'.freeze
  # ASSUMED_TIMEZONE = 'America/New_York'.freeze
  DEFAULT_DATETIME_OUTPUT_FORMAT = '%c %Z'.freeze

  def self.parse_page_url(url)
    # page = Nokogiri::HTML(open("leisure-drop-in.html"))
    page = Nokogiri::HTML(open(url))
    self.parse_document(page)
  end

  def self.parse_document(page)
    listings = page.css('.pfrProgramDescrList .pfrListing')
    listings.each { |location_html|
    location_name = location_html.css('h2 a').text
    # Sanity check - does the table have the expected columns?
    table_header = location_html.css('table thead tr th').text.strip
    raise "Unexpected table heading '#{table_header}'" if table_header != 'Program  Sun  Mon  Tue  Wed  Thu  Fri  Sat'
    weeks_html = location_html.css('table tbody tr')
    weeks_html.each { |week_html|
      activity_title = week_html.css('th div').text.strip
      row_title =  week_html.css('th').text.strip
      week_dates =
        row_title[activity_title.length..row_title.length].strip.split(' to ')
      hours_cells_html = week_html.css('td')
      hours_cells_html.each_with_index  { |hours_cell_html, day_offset|
        hours_text = hours_cell_html.text.strip
        # sometimes we get a blank with just a space
        # TODO: it should not come back as blank!
        next if hours_text.length == 1

        range = parse_range(week_dates[0], day_offset, hours_text)

        # Assert that we have the matching day of the week
        day_of_the_week_attr = hours_cell_html.attr('data-info')
        raise "Unexpected day of the week '#{range[0].strftime('%a')}' doesn't match '#{day_of_the_week_attr}'" if range[0].strftime('%a') != day_of_the_week_attr

        # location_name: York Recreation Centre
        # activity_title: Leisure Swim
        # logger.info("'#{activity_title}' at '#{location_name}'; '#{range[0].strftime(DEFAULT_DATETIME_OUTPUT_FORMAT)}' - '#{range[1].strftime(DEFAULT_DATETIME_OUTPUT_FORMAT)}'")
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
    # TODO: Figure out timezones
    from_datetime = DateTime.strptime("#{date} #{times[0]}", STRPTIME_FORMAT_DATETIME)
    to_datetime = DateTime.strptime("#{date} #{times[1]}", STRPTIME_FORMAT_DATETIME)
    from_datetime = from_datetime.next_day(offset_days)
    to_datetime = to_datetime.next_day(offset_days)
    [from_datetime, to_datetime]
  end
end
