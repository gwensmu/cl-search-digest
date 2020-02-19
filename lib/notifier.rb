# frozen_string_literal: true

require 'erb'
require 'aws-sdk'
require_relative 'cl_search'

# Send an email digest of
# Craigslist search results
class Notifier
  attr_accessor :sender, :recipient, :listings

  def initialize(config)
    search = ClSearch.new(config)
    @listings = search.call
    @category = search.category
    @sender = config['sender']
    @recipient = config['recipient']
    @body_html = build_email_body if @listings.any?
    @subject_text = "#{@listings.count} New #{@category} Today"
  end

  def build_email_body
    b = binding
    template_path = File.join(File.dirname(__FILE__), '../views/index.erb')
    body = ERB.new(File.read(template_path)).result b
    body.encode('UTF-8',
                'binary',
                invalid: :replace,
                undef: :replace,
                replace: '')
  end

  def deliver(client: nil)
    if @listings.empty?
      puts "no new #{@category} today: #{Date.today}"
      return
    end
    # TODO: pull region from env vars
    client ||= Aws::SES::Client.new(region: 'us-west-2')
    client.send_email({
                        destination: {
                          to_addresses: [@recipient]
                        },
                        message: {
                          body: {
                            html: {
                              charset: 'UTF-8',
                              data: @body_html
                            }
                          },
                          subject: {
                            charset: 'UTF-8',
                            data: @subject_text
                          }
                        },
                        reply_to_addresses: [@sender],
                        source: @sender
                      })
  rescue Aws::SES::Errors::ServiceError => e
    puts "Email not sent. Error message: #{e}"
  end
end
