require 'rubygems'
require 'action_mailer'
require 'mail'
require 'ammeter/init'
require File.expand_path(File.dirname(__FILE__) + '/../lib/email_spec.rb')

RSpec.configure do |config|
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  def matcher_failure_message(matcher)
    matcher.respond_to?(:failure_message_for_should) ?
        matcher.failure_message_for_should :
        matcher.failure_message
  end

  def matcher_failure_message_when_negated(matcher)
    matcher.respond_to?(:failure_message_for_should_not) ?
        matcher.failure_message_for_should_not :
        matcher.negative_failure_message
  end
end
