require 'nokogiri'
require 'open-uri'

class LocationParser
  # Column names
  LOCATIONNAME = 'Name'
  LATITUDE = 'Y_COORD'
  LONGITUDE = 'X_COORD'
  ADDRESS = 'address'
  PHONE = 'telephone'
  CATEGORY = 'category'
  ID = 'locationID'

  def self.parse(url)
    Nokogiri::XML(open(url))
      .xpath('/POOLS/ROW')
      .map { |row| parse_row(row) }
      .uniq # Ignore indoor/outdoor for same location, only need it once
  end

  private

  def self.parse_row(row)
    {
      id: parse_column(row, ID).to_i,
      name: parse_column(row, LOCATIONNAME),
      latitude: parse_column(row, LATITUDE).to_f,
      longitude: parse_column(row, LONGITUDE).to_f,
      address: parse_column(row, ADDRESS),
      phone: parse_column(row, PHONE),
      category: parse_column(row, CATEGORY),
    }
  end

  def self.parse_column(row, colname)
    text = row.xpath("./COLUMN[@NAME=\"#{colname}\"]").text.strip
    text.empty? ? nil : text
  end
end
