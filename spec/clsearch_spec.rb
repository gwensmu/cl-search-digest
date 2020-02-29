# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require_relative '../lib/cl_search'
require 'spec_helper'
require 'rspec'
require 'yaml'

describe 'ClSearch' do
  it 'will parse RSS results from search' do
    search = ClSearch.new(YAML.safe_load(File.open('spec/config.yml', 'r')))
    results = search.call.first
    expect(results.title).to eq 'Rag Rug Weaving Loom (78 n bryan St)'
    expect(results.url).to eq 'https://madison.craigslist.org/art/d/madison-rag-rug-weaving-loom/6914212324.html'
    expect(results.description).to include 'This is a two-harness rug loom'
    expect(results.timestamp.to_s).to eq '2019-07-10 17:35:09 -0500'
  end

  it 'will dedup search results' do
    search = ClSearch.new(YAML.safe_load(File.open('spec/config.yml', 'r')))
    results = search.call

    expect(results.count).to eq 2
  end

  it 'will build a URI from config'
end
