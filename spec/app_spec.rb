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

  it "filters out duplicate postings on craigslist" do
    listing1 = LoomSearch::Listing.new(title: "loom", description: "weaves fabric", dc_date: Date.today)
    listing2 = LoomSearch::Listing.new(title: "loom", description: "weaves fabric", dc_date: Date.today)
    listing3 = LoomSearch::Listing.new(title: "macomber", description: "36 harnesses", dc_date: Date.today)

    listings = [listing1, listing2, listing3]
    expect(LoomSearch.new({}).dedup(listings).count).to be 2
  end

  it "filters out irrelevant posts by keyword" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).not_to include("Lloyd")
    expect(last_response.body).not_to include("lloyd")
    expect(last_response.body).not_to include("LLOYD")
  end
end
