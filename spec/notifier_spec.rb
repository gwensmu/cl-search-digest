require 'simplecov'
SimpleCov.start

require_relative "../lib/notify"
require "rspec"

notifier = Notifier.new(YAML.load(File.open("spec/config.yml", "r")))

describe "Notifier" do
  it "initalizes a Notifier object from config" do
    expect(notifier.sender).to eq "test@test.com"
  end

  it "will send via sendmail" do
    notifier.delivery_method = :sendmail

    allow(Mail).to receive(:deliver) do |mail|
      return mail
    end

    expect(notifier).to receive(:deliver_via_sendmail)
    expect(notifier).not_to receive(:deliver_via_aws_ses)
    notifier.deliver
  end

  it "will send via SES" do
    notifier.delivery_method = :aws_ses

    ses = Aws::SES::Client.new
    ses.stub_data(:send_email)

    expect(notifier).not_to receive(:deliver_via_sendmail)
    expect(notifier).to receive(:deliver_via_aws_ses)
    notifier.deliver(client: ses)
  end
end
