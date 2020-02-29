# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require_relative '../lib/cl_search'
require 'spec_helper'
require 'rspec'
require 'yaml'

describe 'ClSearch' do
  let(:search) do
    ClSearch.new(YAML.safe_load(File.open('spec/config.yml', 'r')))
  end

  it 'will parse RSS results from search' do
    results = search.call.first
    expect(results.title).to eq 'Rag Rug Weaving Loom (78 n bryan St)'
    expect(results.url).to eq 'https://madison.craigslist.org/art/d/madison-rag-rug-weaving-loom/6914212324.html'
    expect(results.description).to include 'This is a two-harness rug loom'
    expect(results.timestamp.to_s).to eq '2019-07-10 17:35:09 -0500'
  end

  it 'will dedup search results' do
    results = search.call
    expect(results.count).to eq 2
  end

  it 'will build a collection URIs from config' do
    expect(search.search_uris).to be_a(Array)
    expect(search.search_uris.first).to eq 'https://milwaukee.craigslist.org/search/sss?format=rss&query=red+%7C+wig+-lloyd&sort=rel&srchType=T&hasPic=1&search_distance=200&postal=60641&postedToday=1'
  end
end
