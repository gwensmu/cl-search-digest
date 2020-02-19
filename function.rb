# frozen_string_literal: true

require 'yaml'
require_relative 'lib/notifier'

def handler(*)
  path_to_config = File.join(File.dirname(__FILE__), 'config/default.yml')
  config = YAML.safe_load(File.read(path_to_config))

  Notifier.new(config).deliver
end
