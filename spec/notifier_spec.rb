require 'simplecov'
SimpleCov.start

require_relative "../lib/notify"
require "rspec"

describe "Notifier" do
  it "initalizes a Notifier object from config" do
    email = Notifier.new(YAML.load(File.open("spec/config.yml", "r")))
    expect(email.sender).to eq "test@test.com"
  end
end
