# frozen_string_literal: true

require 'simple-rss'
require 'net/http'

# Search Craiglist and return deduped, filtered listings
class ClSearch
  attr_accessor :category, :search_uris

  def initialize(config)
    @config = config
    @search_uris = build_search_uris(config['cities']) || []
    @category = config['category'] || ''
  end

  def call
    listings = []
    @search_uris.each do |search|
      uri = URI(search)
      response = Net::HTTP.get(uri)

      rss = SimpleRSS.parse response
      rss.entries.each do |entry|
        listings << Listing.new(entry)
      end
    end
    dedup(listings)
  end

  def dedup(listings)
    listings
      .uniq { |l| [l.description, l.title] }
      .sort_by!(&:timestamp).reverse
  end

  def build_search_uri(city)
    search_terms = @config['search_terms'].join('+%7C+')
    # TODO: handle prepending the "+-" on excluded terms only if they exist
    excluded_terms = @config['excluded_terms'].join('+-').gsub(' ', '%7C')
    zip = @config['zip'] ||= '60641'
    radius = @config['search_radius'] ||= 200
    "https://#{city}.craigslist.org/search/sss?format=rss&query=#{search_terms}+-#{excluded_terms}&sort=rel&srchType=T&hasPic=1&search_distance=#{radius}&postal=#{zip}&postedToday=1"
  end

  def build_search_uris(cities)
    cities.map { |city| build_search_uri(city) }
  end

  # A posting on Craigslist
  class Listing
    attr_accessor :title, :description, :images, :timestamp, :url

    def initialize(item)
      @title = item[:title]
      @url = item[:link]
      @description = item[:description]
      @timestamp = item[:dc_date]
    end
  end
end
