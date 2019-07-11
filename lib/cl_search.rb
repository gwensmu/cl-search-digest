require "simple-rss"
require "net/http"

# Search Craiglist and return deduped, filtered listings
class ClSearch
  attr_accessor :category

  def initialize(config)
    @search_uris = config["search_uris"] || []
    @blacklist = config["excluded_terms"] || []
    @category = config["category"] || ""
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
      .uniq { |l| [ l.description, l.title ] }
      .sort_by! {|l| l.timestamp }.reverse
  end

  def includes_excluded_terms?(item)
    @blacklist.any? { |phrase| item[:description].downcase.include?(phrase) } ||
      @blacklist.any? { |phrase| item[:title].downcase.include?(phrase) }
  end

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
