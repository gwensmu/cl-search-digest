# frozen_string_literal: true

require 'sinatra/base'

class MockList < Sinatra::Base
  get '*' do
    rss_response 200, 'milwaukee.xml'
  end

  private

  def rss_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
