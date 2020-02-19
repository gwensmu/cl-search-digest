# frozen_string_literal: true

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require_relative 'support/mocklist'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /milwaukee.craigslist.org/).to_rack(MockList)
  end
end
