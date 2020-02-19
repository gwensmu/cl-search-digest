# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'spec_helper'
require_relative '../lib/notifier'
require 'rspec'
require 'yaml'

describe 'Notifier' do
  notifier = Notifier.new(YAML.safe_load(File.open('spec/config.yml', 'r')))

  it 'initalizes a Notifier object from config' do
    expect(notifier.sender).to eq 'test@test.com'
    expect(notifier.recipient).to eq 'gwen.smuda@gmail.com'
  end

  it 'will search Craigslist' do
    expect(notifier.listings).not_to be_empty
  end

  it 'will send via SES' do
    ses = Aws::SES::Client.new
    ses.stub_data(:send_email)

    expect(notifier).to receive(:deliver)
    notifier.deliver(client: ses)
  end
end
