require "yaml"
require_relative "../lib/notify"

path_to_config = File.join(File.dirname(__FILE__), "../config/config.yml")
config = YAML.load(File.read(path_to_config))

Notifier.new(config).deliver
