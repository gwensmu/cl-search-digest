# frozen_string_literal: true

require 'optparse'
require 'yaml'
require_relative '../lib/notifier'

options = { config: 'default.yml' }
OptionParser.new do |opts|
  opts.on('-config', '--config=config.yml', 'config filename') do |c|
    options[:config] = c
  end
end.parse!

config_path = File.join(File.dirname(__FILE__), "../config/#{options[:config]}")
config = YAML.safe_load(File.read(config_path))

response = Notifier.new(config).deliver
puts response
