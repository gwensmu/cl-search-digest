require "sinatra"
require "sinatra/reloader"
require "markaby"
require "json"
require "logger"
require "yaml"

require_relative "lib/loom_search"

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
  search = LoomSearch.new(YAML.load(File.open("config/config.yml", "r")))
  @listings = search.get_all_nearby
  erb :index
end
