require 'rubygems'
require 'action_mailer'
require 'rspec'
require 'mail'
require 'ammeter/init'
require File.expand_path(File.dirname(__FILE__) + '/../lib/email_spec.rb')

class Mail::Message
  def with_inspect_stub(str = "email")
    stub!(:inspect).and_return(str)
    self
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  def matcher_failure_message(matcher)
    matcher.respond_to?(:failure_message_for_should) ?
        matcher.failure_message_for_should :
        matcher.failure_message
  end

  def matcher_negative_failure_message(matcher)
    matcher.respond_to?(:failure_message_for_should_not) ?
        matcher.failure_message_for_should_not :
        matcher.negative_failure_message
  end
end
