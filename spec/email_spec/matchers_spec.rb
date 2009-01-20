require File.dirname(__FILE__) + '/../spec_helper'

        
describe EmailSpec::Matchers do

  include EmailSpec::Matchers

  def mock_email(stubs)
    mock("email", stubs)
  end

  describe "#deliver_to" do

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

  describe "#have_subject" do

    describe "when regexps are used" do

      it "should match when the subject mathches regexp" do
        email = mock_email(:subject => ' -- The Subject --')

        have_subject(/The Subject/).matches?(email).should be_true
        have_subject(/The Subject/).matches?(email).should be_true
        have_subject(/foo/).matches?(email).should be_false
      end

      it "should have a helpful description" do
        matcher = have_subject(/foo/)
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.description.should == "have subject matching /foo/"
      end

      it "should offer helpful failing messages" do
        matcher = have_subject(/foo/)
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.failure_message.should == 'expected the subject to match /foo/, but did not.  Actual subject was: "bar"'
      end

      it "should offer helpful negative failing messages" do
        matcher = have_subject(/b/)
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.negative_failure_message.should == 'expected the subject not to match /b/ but "bar" does match it.'
      end

    end
      
    describe "when strings are used" do

      it "should match when the subject equals the passed in string exactly" do
        email = mock_email(:subject => 'foo')

        have_subject("foo").matches?(email).should be_true
        have_subject(" - foo -").matches?(email).should be_false
      end

      it "should have a helpful description" do
        matcher = have_subject("foo")
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.description.should == 'have subject of "foo"'
      end

      it "should offer helpful failing messages" do
        matcher = have_subject("foo")
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.failure_message.should == 'expected the subject to be "foo" but was "bar"'
      end


      it "should offer helpful negative failing messages" do
        matcher = have_subject("bar")
        matcher.matches?(mock_email(:subject => "bar"))

        matcher.negative_failure_message.should == 'expected the subject not to be "bar" but was'
      end
      
    end

  end
end
