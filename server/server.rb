require 'sinatra'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

logger.info("Server started")

get '/' do
  'Welcome to BookList!'
end