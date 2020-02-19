# frozen_string_literal: true

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require_relative 'support/mocklist'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /milwaukee.craigslist.org/).to_rack(MockList)

    stub_request(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
  end
end
