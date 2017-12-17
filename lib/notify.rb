require "erb"
require "mail"
require "aws-sdk"
require_relative "cl_search"

class Notifier
  attr_accessor :sender, :recipient, :delivery_method

  def initialize(config)
    search = ClSearch.new(config)
    @listings = search.get_all_nearby
    @category = search.category
    @sender = config["sender"]
    @recipient = config["recipient"]
    @delivery_method = config["delivery_method"].to_sym || :sendmail
  end

  def build_email_body
    b = binding
    template_path = File.join(File.dirname(__FILE__), "../views/index.erb")
    body = ERB.new(File.read(template_path)).result b
    body.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
  end

  def deliver_via_sendmail(sender:"", recipient:"", body_html:"", subject_text:"")
    mail = Mail.new do
      from    sender
      to      recipient
      subject subject_text
      html_part do
        content_type "text/html; charset=UTF-8"
        body body_html
      end
    end
    mail.delivery_method :sendmail
    mail.deliver
    mail
  end

  def deliver_via_aws_ses(sender:"", recipient:"", body_html:"", subject_text:"", client: nil)
    client = Aws::SES::Client.new(region: 'us-west-2') unless client
    resp = client.send_email({
      destination: {
        to_addresses: [recipient],
      },
      message: {
        body: {
          html: {
            charset: "UTF-8",
            data: body_html
          },
        },
        subject: {
          charset: "UTF-8",
          data: subject_text,
        },
      },
      reply_to_addresses: [sender],
      source: sender
    })
    resp
  end

  def deliver(client: nil)
    params = { sender: @sender,
               recipient: @recipient,
               body_html: build_email_body,
               client: client,
               subject_text: "#{@listings.count} #{@category} Available Right Now" }
    if @delivery_method == :sendmail
      resp = deliver_via_sendmail(params)
    else
      resp = deliver_via_aws_ses(params)
    end
    puts resp
    resp
  end
end
