require 'sinatra'
require 'logger'
require 'json'

require_relative 'parser'

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
