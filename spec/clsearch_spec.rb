require 'simplecov'
SimpleCov.start

require_relative "../lib/cl_search"
require 'spec_helper'
require "rspec"
require "yaml"

describe "ClSearch" do
  it "will parse RSS results from search" do
    search = ClSearch.new(YAML.load(File.open("spec/config.yml", "r")))
    results = search.call
    expect(results.first.title).to eq "Rag Rug Weaving Loom (78 n bryan St)"
    expect(results.first.url).to eq "https://madison.craigslist.org/art/d/madison-rag-rug-weaving-loom/6914212324.html"
    expect(results.first.description).to include "This is a two-harness rug loom"
    expect(results.first.timestamp.to_s).to eq "2019-07-10 17:35:09 -0500"
  end

  it "will dedup search results" do
    search = ClSearch.new(YAML.load(File.open("spec/config.yml", "r")))
    results = search.call

    expect(results.count).to eq 2
  end
  
  it "will filter listings with excluded terms" do
    search = ClSearch.new(YAML.load(File.open("spec/config.yml", "r")))
    results = search.call
  
    expect(results.map(&:description)).not_to include "lloyd"
  end
end
