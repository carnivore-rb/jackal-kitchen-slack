$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'jackal-kitchen-slack/version'
Gem::Specification.new do |s|
  s.name = 'jackal-kitchen-slack'
  s.version = Jackal::KitchenSlack::VERSION.version
  s.summary = 'Jackal Kitchen Slack'
  s.author = 'Heavywater'
  s.email = 'support@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/jackal-kitchen-slack'
  s.description = 'Jackal Kitchen Slack'
  s.require_path = 'lib'
  s.add_dependency 'jackal'
  s.files = Dir['**/*']
end
