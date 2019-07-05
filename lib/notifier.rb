require "erb"
require_relative "cl_search"

class Notifier
  attr_accessor :sender, :recipient

  def initialize(config)
    search = ClSearch.new(config)
    @listings = search.get_all_nearby
    @category = search.category
    @sender = config["sender"]
    @recipient = config["recipient"]
    @body_html = build_email_body
    @subject_text = "#{@listings.count} #{@category} New Looms Today"
  end

  def build_email_body
    b = binding
    template_path = File.join(File.dirname(__FILE__), "../views/index.erb")
    body = ERB.new(File.read(template_path)).result b
    body.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
  end

  def deliver(client: nil)
    begin
      # todo: pull region from config
      if @listings.empty?
        puts "no new looms today: #{Date.today}"
        return
      end
      client ||= Aws::SES::Client.new(region: 'us-west-2')
      client.send_email({
        destination: {
          to_addresses: [@recipient],
        },
        message: {
          body: {
            html: {
              charset: "UTF-8",
              data: @body_html
            },
          },
          subject: {
            charset: "UTF-8",
            data: @subject_text,
          },
        },
        reply_to_addresses: [@sender],
        source: @sender
      })
    rescue Aws::SES::Errors::ServiceError => error
      puts "Email not sent. Error message: #{error}"
    end 
  end
end
