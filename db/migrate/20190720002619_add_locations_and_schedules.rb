class AddLocationsAndSchedules < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'plpgsql'
    enable_extension 'postgis'
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    create_table 'locations' do |t|
      t.text 'name', null: false
      t.text 'address', null: false
      t.text 'category', null: false
      t.text 'phone'
      t.geography 'coordinates', limit: {:srid=>4326, :type=>'st_point', :geographic=>true}, null: false
      
      t.timestamps
      t.index ['coordinates'], name: 'index_locations_on_coordinates', using: :gist
    end

    create_table 'schedules', id: false do |t|
      t.references :location, index: true, foreign_key: { to_table: :locations }
      t.text 'activity', null: false
      t.datetime 'time_from', null: false
      t.datetime 'time_to', null: false
    end

    add_index :schedules, [:location_id, :activity, :time_from, :time_to], name: 'index_unique_entry', unique: true
  end
end
