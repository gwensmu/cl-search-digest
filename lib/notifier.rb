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
    @subject_text = "#{@listings.count} #{@category} Available Right Now"
  end

  def build_email_body
    b = binding
    template_path = File.join(File.dirname(__FILE__), "../views/index.erb")
    body = ERB.new(File.read(template_path)).result b
    body.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
  end

  def deliver(client: nil)
    raise NotImplementedError
  end
end
