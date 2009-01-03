require File.dirname(__FILE__) + '/../spec_helper'

module EmailSpec
  module Matchers
        
    def mock_email(stubs)
      mock("email", {:to => "bob@yahoo.com"}.merge(stubs))
    end

    describe DeliverTo do
      include ::EmailSpec::Matchers

      it "should match when the email is set to deliver to the specidied address" do
        email = mock_email(:to => "jimmy_bean@yahoo.com")

        deliver_to("jimmy_bean@yahoo.com").matches?(email).should be_true
      end

      it "should match when a list of emails is exact same as all of the email's recipients" do
        email = mock_email(:to => ["james@yahoo.com", "karen@yahoo.com"])

        deliver_to("karen@yahoo.com", "james@yahoo.com").matches?(email).should be_true
        deliver_to("karen@yahoo.com").matches?(email).should be_false
      end

      it "should use the passed in objects :email method if not a string" do
        email = mock_email(:to => "jimmy_bean@yahoo.com")
        user = mock("user", :email => "jimmy_bean@yahoo.com")

        deliver_to(user).matches?(email).should be_true
      end

    end

  end
end
