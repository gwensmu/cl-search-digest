require_relative "cl_search"
require "erb"
require "mail"

class Notifier
  attr_accessor :sender, :recipient

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

  def deliver
    mail = generate_email
    mail.delivery_method @delivery_method
    mail.deliver
    puts "Delivered an email!"
  end

  def generate_email
    sender = @sender
    recipient = @recipient
    body_html = build_email_body
    subject_text = "#{@listings.count} #{@category} Around Chicago Right Now"
    mail = Mail.new do
      from    sender
      to      recipient
      subject subject_text
      html_part do
        content_type "text/html; charset=UTF-8"
        body body_html
      end
    end
    mail
  end
end
