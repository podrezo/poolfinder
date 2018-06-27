require 'nokogiri'

COLUMN_NAME_LOCATIONNAME = 'Name'
COLUMN_NAME_LATITUDE = 'Y_COORD'
COLUMN_NAME_LONGITUDE = 'X_COORD'
COLUMN_NAME_ADDRESS = 'address'
COLUMN_NAME_INTERSECTION = 'intersection'
COLUMN_NAME_PHONE = 'telephone'
COLUMN_NAME_CATEGORY = 'category'

VALID_POOL_TYPES = ['Indoor Pool', 'Outdoor Pool']

class LocationParser
  def self.parse(url = 'dataloader/static_data/pools.xml')
    xml_doc = Nokogiri::XML(open(url))
    xml_doc.xpath('/POOLS/ROW')
      .select { |row|
        # Ignore wading pools, splash pads, etc. Only real pools
        category = col_to_text(COLUMN_NAME_CATEGORY, row)
        VALID_POOL_TYPES.include?(category)
      }
      .map { |row|
        {
          name: col_to_text(COLUMN_NAME_LOCATIONNAME, row),
          coordinates: {
            latitude: col_to_text(COLUMN_NAME_LATITUDE, row).to_f,
            longitude: col_to_text(COLUMN_NAME_LONGITUDE, row).to_f,
          },
          address: col_to_text(COLUMN_NAME_ADDRESS, row),
          intersection: col_to_text(COLUMN_NAME_INTERSECTION, row),
          phone: col_to_text(COLUMN_NAME_PHONE, row),
          category: col_to_text(COLUMN_NAME_CATEGORY, row),
        }
      }
      .uniq # Ignore indoor/outdoor for same location, only need it once
  end

  private

  def self.col_to_text(colname, row)
    row.xpath("./COLUMN[@NAME=\"#{colname}\"]").text
  end
end