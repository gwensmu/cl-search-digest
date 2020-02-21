# frozen_string_literal: true

require 'simple-rss'
require 'net/http'

# Search Craiglist and return deduped, filtered listings
class ClSearch
  attr_accessor :category

  def initialize(config)
    @search_uris = config['search_uris'] || []
    @blacklist = config['excluded_terms'] || []
    @category = config['category'] || ''
  end

  def call
    listings = []
    @search_uris.each do |search|
      uri = URI(search)
      response = Net::HTTP.get(uri)

      rss = SimpleRSS.parse response
      rss.entries.each do |entry|
        listings << Listing.new(entry) unless includes_excluded_terms?(entry)
      end
    end
    dedup(listings)
  end

  def dedup(listings)
    listings
      .uniq { |l| [l.description, l.title] }
      .sort_by!(&:timestamp).reverse
  end

  # todo: use benchmark to explore if this is better performance
  def includes_excluded_terms?(item)
    title_plus_description = item[:description] + item[:title]
    listing_terms = Set.new(title_plus_description.split(" "))
    listing_terms.intersect? Set.new(@blacklist)
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
