ENV["RACK_ENV"] = "test"

require 'simplecov'
SimpleCov.start

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
    listing1 = ClSearch::Listing.new(title: "loom", description: "weaves fabric", dc_date: Date.today)
    listing2 = ClSearch::Listing.new(title: "loom", description: "weaves fabric", dc_date: Date.today)
    listing3 = ClSearch::Listing.new(title: "macomber", description: "36 harnesses", dc_date: Date.today)

    listings = [listing1, listing2, listing3]
    expect(ClSearch.new({}).dedup(listings).count).to be 2
  end

  it "identifies listings that contain words in the blacklist" do
    search = ClSearch.new(YAML.load(File.open("spec/config.yml", "r")))
    item1 = {description: "lloyd loom wicker armchair", title: "furniture"}
    item2 = {title: "rainbow loom bands", description: "welp"}
    item3 = {title: "macomber", description: "free and dreamy"}

    expect(search.includes_excluded_terms?(item1)).to be true
    expect(search.includes_excluded_terms?(item2)).to be true
    expect(search.includes_excluded_terms?(item3)).to be false
  end

  it "filters out irrelevant posts by keyword" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).not_to include("Lloyd")
    expect(last_response.body).not_to include("lloyd")
    expect(last_response.body).not_to include("LLOYD")
  end
end
