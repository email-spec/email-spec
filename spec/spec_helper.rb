require 'rubygems'
require 'action_mailer'
require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../lib/email_spec.rb')

Rspec.configure do |config|
  config.mock_with :rspec
end