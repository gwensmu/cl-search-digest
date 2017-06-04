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

  it "filters out duplicate postings on craigslist"

  it "concatenates the results from multiple searches"

  it "filters out irrelevant posts by keyword" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).not_to include("Lloyd")
    expect(last_response.body).not_to include("lloyd")
    expect(last_response.body).not_to include("LLOYD")
  end
end
