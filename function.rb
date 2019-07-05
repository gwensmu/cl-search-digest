require "yaml"
require_relative "lib/aws_notifier"

def handler(event:, context:)
  path_to_config = File.join(File.dirname(__FILE__), "config/default.yml")
  config = YAML.load(File.read(path_to_config))

  AwsNotifier.new(config).deliver
end