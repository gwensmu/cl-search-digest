require "optparse"
require "yaml"
require_relative "../lib/aws_notifier"
require_relative "../lib/sendmail_notifier"

options = {config: "default.yml"}
OptionParser.new do |opts|
  opts.on("-config", "--config=drumconfig.yml", "path to config from config dir") do |c|
    options[:config] = c
  end
end.parse!

path_to_config = File.join(File.dirname(__FILE__), "../config/#{options[:config]}")
config = YAML.load(File.read(path_to_config))

if config["delivery_method"] == "sendmail"
  response = SendmailNotifier.new(config).deliver
else
  response = AwsNotifier.new(config).deliver
end
puts response
