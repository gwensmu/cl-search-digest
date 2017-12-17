require "optparse"
require "yaml"
require_relative "../lib/notify"

options = {config: "config.yml"}
OptionParser.new do |opts|
  opts.on("-config", "--config=drumconfig.yml", "path to config from config dir") do |c|
    options[:config] = c
  end
end.parse!

path_to_config = File.join(File.dirname(__FILE__), "../config/#{options[:config]}")
config = YAML.load(File.read(path_to_config))

response = Notifier.new(config).deliver
puts response
