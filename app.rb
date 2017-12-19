require "sinatra"
require "sinatra/reloader"
require "json"
require "logger"
require "yaml"

require_relative "lib/cl_search"

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
  search = ClSearch.new(YAML.load(File.open("config/default.yml", "r")))
  @listings = search.get_all_nearby
  @category = search.category
  erb :index
end

get "/:name" do
  config = "config/#{params[:name]}.yml"
  begin
    search = ClSearch.new(YAML.load(File.open(config, "r")))
  rescue
    search = ClSearch.new(YAML.load(File.open("config/default.yml", "r")))
  end
  @listings = search.get_all_nearby
  @category = search.category
  erb :index
end
