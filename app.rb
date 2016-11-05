require "sinatra"
require "sinatra/reloader"
require "markaby"
require "json"
require "logger"

require_relative "app/listing"

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :show_exceptions, :after_handler
end

configure :development do
  register Sinatra::Reloader
  $logger = Logger.new(STDOUT)
end

set :show_exceptions, false

get "/" do
  @listings = LoomSearch.get_all_nearby
  markaby :index
end
