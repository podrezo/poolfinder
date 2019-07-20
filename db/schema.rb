# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_20_002619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "locations", force: :cascade do |t|
    t.text "name", null: false
    t.text "address", null: false
    t.text "category", null: false
    t.text "phone"
    t.geography "coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinates"], name: "index_locations_on_coordinates", using: :gist
  end

  create_table "schedules", id: false, force: :cascade do |t|
    t.bigint "location_id"
    t.text "activity", null: false
    t.datetime "time_from", null: false
    t.datetime "time_to", null: false
    t.index ["location_id", "activity", "time_from", "time_to"], name: "index_unique_entry", unique: true
    t.index ["location_id"], name: "index_schedules_on_location_id"
  end

  add_foreign_key "schedules", "locations"
end
