require "simple-rss"
require "net/http"

# search Craiglist for weaving looms near Chicago
module LoomSearch
  def self.get_all_nearby
    query_string = "http://chicago.craigslist.org/search/sss?format=rss&query=weaving+loom&sort=rel&searchNearby=2&nearbyArea=243&nearbyArea=628&nearbyArea=344&nearbyArea=190&nearbyArea=569&nearbyArea=362&nearbyArea=226&nearbyArea=129&nearbyArea=630&nearbyArea=45&nearbyArea=426&nearbyArea=553&nearbyArea=261&nearbyArea=552&nearbyArea=672&nearbyArea=698&nearbyArea=360&nearbyArea=212&nearbyArea=165&nearbyArea=699&nearbyArea=47&nearbyArea=361&nearbyArea=554&nearbyArea=224&nearbyArea=307&nearbyArea=223&nearbyArea=571&nearbyArea=228&nearbyArea=572&nearbyArea=348"
    uri = URI(query_string)
    response = Net::HTTP.get(uri)

    rss = SimpleRSS.parse response
    listings = []
    rss.entries.each do |entry|
      listings << Listing.new(entry)
    end
    listings
  end

  class Listing
    attr_accessor :title, :description, :images, :timestamp, :url

    def initialize(item)
      @title = item[:title]
      @url = item[:link]
      @description = item[:description]
      @timestamp = item[:dc_date]
      # @images = params[:img_urls]
    end
  end
end
