require 'nokogiri'

class LocationParser
  # Column names
  LOCATIONNAME = 'Name'
  LATITUDE = 'Y_COORD'
  LONGITUDE = 'X_COORD'
  ADDRESS = 'address'
  INTERSECTION = 'intersection'
  PHONE = 'telephone'
  CATEGORY = 'category'

  VALID_POOL_TYPES = ['Indoor Pool', 'Outdoor Pool']

  def self.parse(url = 'dataloader/static_data/pools.xml')
    Nokogiri::XML(open(url))
      .xpath('/POOLS/ROW')
      .select { |row| valid_location?(row) }
      .map { |row| parse_row(row) }
      .uniq # Ignore indoor/outdoor for same location, only need it once
  end

  private

  def self.valid_location?(row)
    # Ignore wading pools, splash pads, etc. Only real pools
    category = parse_column(row, CATEGORY)
    VALID_POOL_TYPES.include?(category)
  end

  def self.parse_row(row)
    {
      name: parse_column(row, LOCATIONNAME),
      coordinates: {
        latitude: parse_column(row, LATITUDE).to_f,
        longitude: parse_column(row, LONGITUDE).to_f,
      },
      address: parse_column(row, ADDRESS),
      intersection: parse_column(row, INTERSECTION),
      phone: parse_column(row, PHONE),
      category: parse_column(row, CATEGORY),
    }
  end

  def self.parse_column(row, colname)
    row.xpath("./COLUMN[@NAME=\"#{colname}\"]").text
  end
end
