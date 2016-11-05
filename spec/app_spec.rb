ENV["RACK_ENV"] = "test"

require_relative "../app"
require "rspec"
require "rack/test"
require "pry"
require "json"

describe "App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "shows all nearby listings for weaving looms" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to include("weaving loom")
  end
end
