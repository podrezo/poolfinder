require 'sinatra'
require 'logger'
require 'json'
require 'sqlite3'

require_relative 'constants'
require_relative 'parser'
require_relative 'db'

db = ActivitiesDatabase.new(SQLite3::Database.new('sqlite.db'))
schedule = InfoParser.parse_page_url('leisure-drop-in.html')
db.load_schedule(schedule)

# Guide on how to create server at
# https://x-team.com/blog/how-to-create-a-ruby-api-with-sinatra/
# Style guide at https://github.com/bbatsov/ruby-style-guide

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

logger.info('Server started')

before do
  content_type 'application/json'
end

get '/api/schedule' do
  InfoParser.parse_page_url('leisure-drop-in.html').to_json_formattable.to_json
end

get '/api/open-now' do
  q = db.db.prepare 'SELECT location_id, name, dt_from, dt_to FROM activities WHERE dt_from<? AND ?<dt_to'
  q.bind_param(1, DateTime.now.format(SQLITE_DATE_FORMAT))
  result = q.execute
  activities = []
  result.each do |activity_row|
    activites.push({
      'name' => activity_row[1],
      'from' => activity_row[2],
      'to' => activity_row[3]
    })
  end
  return activities
end