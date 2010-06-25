require File.dirname(__FILE__) + '/../spec_helper'

describe EmailSpec::Helpers do
  include EmailSpec::Helpers
  describe "#parse_email_for_link" do
    it "properly finds links with text" do
      email = Mail.new(:body =>  %(<a href="/path/to/page">Click Here</a>))
      parse_email_for_link(email, "Click Here").should == "/path/to/page"
    end

    it "recognizes img alt properties as text" do
      email = Mail.new(:body => %(<a href="/path/to/page"><img src="http://host.com/images/image.gif" alt="an image" /></a>))
      parse_email_for_link(email, "an image").should == "/path/to/page"
    end

    it "causes a spec to fail if the body doesn't contain the text specified to click" do
      email = Mail.new(:body => "")
      lambda { parse_email_for_link(email, "non-existent text") }.should raise_error(  RSpec::Expectations::ExpectationNotMetError)
    end
  end
end
