require File.dirname(__FILE__) + '/../spec_helper'

describe EmailSpec::Matchers do
  include EmailSpec::Matchers

  class MatcherMatch
    def initialize(object_to_test_match)
      @object_to_test_match = object_to_test_match
    end

    def description
      "match when provided #{@object_to_test_match.inspect}"
    end

    def matches?(matcher)
      @matcher = matcher
      matcher.matches?(@object_to_test_match)
    end

    def failure_message
      "expected #{@matcher.inspect} to match when provided #{@object_to_test_match.inspect}, but it did not"
    end

    def failure_message_when_negated
      "expected #{@matcher.inspect} not to match when provided #{@object_to_test_match.inspect}, but it did"
    end
    alias negative_failure_message failure_message_when_negated
  end

  def match(object_to_test_match)
    if object_to_test_match.is_a?(Regexp)
      super # delegate to rspec's built in 'match' matcher
    else
      MatcherMatch.new(object_to_test_match)
    end
  end

  describe "#reply_to" do
    it "should match when the email is set to deliver to the specified address" do
      email = Mail::Message.new(:reply_to => ["test@gmail.com"])
      expect(reply_to("test@gmail.com")).to match(email)
    end

    it "should match given a name and address" do
      email = Mail::Message.new(:reply_to => ["test@gmail.com"])
      expect(reply_to("David Balatero <test@gmail.com>")).to match(email)
    end

    it "should give correct failure message when the email is not set to deliver to the specified address" do
      matcher = reply_to("jimmy_bean@yahoo.com")
      message = Mail::Message.new(:reply_to => ['freddy_noe@yahoo.com'])
      allow(message).to receive(:inspect).and_return("email")
      matcher.matches?(message)
      expect(matcher_failure_message(matcher)).to eq(%{expected email to reply to "jimmy_bean@yahoo.com", but it replied to "freddy_noe@yahoo.com"})
    end

  end

  describe "#deliver_to" do
    it "should match when the email is set to deliver to the specified address" do
      email = Mail::Message.new(:to => "jimmy_bean@yahoo.com")

      expect(deliver_to("jimmy_bean@yahoo.com")).to match(email)
    end

    it "should match when the email is set to deliver to the specified name and address" do
      email = Mail::Message.new(:to => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_to("Jimmy Bean <jimmy_bean@yahoo.com>")).to match(email)
    end

    it "should match when a list of emails is exact same as all of the email's recipients" do
      email = Mail::Message.new(:to => ["james@yahoo.com", "karen@yahoo.com"])

      expect(deliver_to("karen@yahoo.com", "james@yahoo.com")).to match(email)
      expect(deliver_to("karen@yahoo.com")).not_to match(email)
    end

    it "should match when an array of emails is exact same as all of the email's recipients" do
      addresses = ["james@yahoo.com", "karen@yahoo.com"]
      email = Mail::Message.new(:to => addresses)
      expect(deliver_to(addresses)).to match(email)
    end

    it "should match when the names and email addresses match in any order" do
      addresses = ["James <james@yahoo.com>", "Karen <karen@yahoo.com>"]
      email = Mail::Message.new(:to => addresses.reverse)
      expect(deliver_to(addresses)).to match(email)
    end

    it "should use the passed in objects :email method if not a string" do
      email = Mail::Message.new(:to => "jimmy_bean@yahoo.com")
      user = double("user", :email => "jimmy_bean@yahoo.com")

      expect(deliver_to(user)).to match(email)
    end

    it "should not match when the email does not have a recipient" do
      email = Mail::Message.new(:to => nil)
      expect(deliver_to("jimmy_bean@yahoo.com")).not_to match(email)
    end

    it "should not match when the email addresses match but the names do not" do
      email = Mail::Message.new(:to => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_to("Freddy Noe <jimmy_bean@yahoo.com>")).not_to match(email)
    end

    it "should not match when the names match but the email addresses do not" do
      email = Mail::Message.new(:to => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_to("Jimmy Bean <freddy_noe@yahoo.com>")).not_to match(email)
    end

    it "should give correct failure message when the email is not set to deliver to the specified address" do
      matcher = deliver_to("jimmy_bean@yahoo.com")
      message = Mail::Message.new(:to => 'freddy_noe@yahoo.com')
      allow(message).to receive(:inspect).and_return("email")
      matcher.matches?(message)
      expect(matcher_failure_message(matcher)).to eq(%{expected email to deliver to ["jimmy_bean@yahoo.com"], but it delivered to ["freddy_noe@yahoo.com"]})
    end

    it "should deliver to nobody when the email does not perform deliveries" do
      email = Mail::Message.new(:to => "jimmy_bean@yahoo.com")
      email.perform_deliveries = false
      expect(deliver_to("jimmy_bean@yahoo.com")).not_to match(email)
    end

  end

  describe "#deliver_from" do
    it "should match when the email is set to deliver from the specified address" do
      email = Mail::Message.new(:from => "jimmy_bean@yahoo.com")
      expect(deliver_from("jimmy_bean@yahoo.com")).to match(email)
    end

    it "should match when the email is set to deliver from the specified name and address" do
      email = Mail::Message.new(:from => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_from("Jimmy Bean <jimmy_bean@yahoo.com>")).to match(email)
    end

    it "should not match when the email does not have a sender" do
      email = Mail::Message.new(:from => "johnshow@yahoo.com")
      expect(deliver_from("jimmy_bean@yahoo.com")).not_to match(email)
    end

    it "should not match when the email addresses match but the names do not" do
      email = Mail::Message.new(:from => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_from("Freddy Noe <jimmy_bean@yahoo.com>")).not_to match(email)
    end

    it "should not match when the names match but the email addresses do not" do
      email = Mail::Message.new(:from => "Jimmy Bean <jimmy_bean@yahoo.com>")
      expect(deliver_from("Jimmy Bean <freddy_noe@yahoo.com>")).not_to match(email)
    end

    it "should not match when the email is not set to deliver from the specified address" do
      email = Mail::Message.new(:from => "freddy_noe@yahoo.com")
      expect(deliver_from("jimmy_bean@yahoo.com")).not_to match(email)
    end

    it "should give correct failure message when the email is not set to deliver from the specified address" do
      matcher = deliver_from("jimmy_bean@yahoo.com")
      matcher.matches?(Mail::Message.new(:from => "freddy_noe@yahoo.com"))
      expect(matcher_failure_message(matcher)).to match(/expected .+ to deliver from "jimmy_bean@yahoo\.com", but it delivered from "freddy_noe@yahoo\.com"/)
    end

    it "should not deliver from anybody when perform_deliveries is false" do
      email = Mail::Message.new(:from => "freddy_noe@yahoo.com")
      email.perform_deliveries = false
      expect(deliver_from("freddy_noe@yahoo.com")).not_to match(email)
    end

  end

  describe "#bcc_to" do

    it "should match when the email is set to deliver to the specidied address" do
      email = Mail::Message.new(:bcc => "jimmy_bean@yahoo.com")

      expect(bcc_to("jimmy_bean@yahoo.com")).to match(email)
    end

    it "should match when the email is set to deliver to the specified name and address" do
      email = Mail::Message.new(:bcc => "Jimmy Bean <jimmy_bean@yahoo.com>")

      expect(bcc_to("Jimmy Bean <jimmy_bean@yahoo.com>")).to match(email)
    end

    it "should match when a list of emails is exact same as all of the email's recipients" do
      email = Mail::Message.new(:bcc => ["james@yahoo.com", "karen@yahoo.com"])

      expect(bcc_to("karen@yahoo.com", "james@yahoo.com")).to match(email)
      expect(bcc_to("karen@yahoo.com")).not_to match(email)
    end

    it "should match when an array of emails is exact same as all of the email's recipients" do
      addresses = ["james@yahoo.com", "karen@yahoo.com"]
      email = Mail::Message.new(:bcc => addresses)
      expect(bcc_to(addresses)).to match(email)
    end

    it "should use the passed in objects :email method if not a string" do
      email = Mail::Message.new(:bcc => "jimmy_bean@yahoo.com")
      user = double("user", :email => "jimmy_bean@yahoo.com")

      expect(bcc_to(user)).to match(email)
    end

    it "should bcc to nobody when the email does not perform deliveries" do
      email = Mail::Message.new(:bcc => "jimmy_bean@yahoo.com")
      email.perform_deliveries = false
      expect(bcc_to("jimmy_bean@yahoo.com")).not_to match(email)
    end

  end

  describe "#cc_to" do

    it "should match when the email is set to deliver to the specified address" do
      email = Mail::Message.new(:cc => "jimmy_bean@yahoo.com")

      expect(cc_to("jimmy_bean@yahoo.com")).to match(email)
    end

    it "should match when the email is set to deliver to the specified name and address" do
      email = Mail::Message.new(:cc => "Jimmy Bean <jimmy_bean@yahoo.com>")

      expect(cc_to("Jimmy Bean <jimmy_bean@yahoo.com>")).to match(email)
    end

    it "should match when a list of emails is exact same as all of the email's recipients" do
      email = Mail::Message.new(:cc => ["james@yahoo.com", "karen@yahoo.com"])

      expect(cc_to("karen@yahoo.com", "james@yahoo.com")).to match(email)
      expect(cc_to("karen@yahoo.com")).not_to match(email)
    end

    it "should match when an array of emails is exact same as all of the email's recipients" do
      addresses = ["james@yahoo.com", "karen@yahoo.com"]
      email = Mail::Message.new(:cc => addresses)
      expect(cc_to(addresses)).to match(email)
    end

    it "should use the passed in objects :email method if not a string" do
      email = Mail::Message.new(:cc => "jimmy_bean@yahoo.com")
      user = double("user", :email => "jimmy_bean@yahoo.com")

      expect(cc_to(user)).to match(email)
    end

    it "should cc to nobody when the email does not perform deliveries" do
      email = Mail::Message.new(to: "jimmy_bean@yahoo.com")
      email.perform_deliveries = false
      expect(cc_to("jimmy_bean@yahoo.com")).not_to match(email)
    end

  end

  describe "#have_subject" do

    describe "when regexps are used" do

      it "should match when the subject matches regexp" do
        email = Mail::Message.new(:subject => ' -- The Subject --')

        expect(have_subject(/The Subject/)).to match(email)
        expect(have_subject(/foo/)).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_subject(/foo/)
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher.description).to eq("have subject matching /foo/")
      end

      it "should offer helpful failing messages" do
        matcher = have_subject(/foo/)
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher_failure_message(matcher)).to eq('expected the subject to match /foo/, but did not.  Actual subject was: "bar"')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_subject(/b/)
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected the subject not to match /b/ but "bar" does match it.')
      end
    end

    describe "when strings are used" do
      it "should match when the subject equals the passed in string exactly" do
        email = Mail::Message.new(:subject => 'foo')

        expect(have_subject("foo")).to match(email)
        expect(have_subject(" - foo -")).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_subject("foo")
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher.description).to eq('have subject of "foo"')
      end

      it "should offer helpful failing messages" do
        matcher = have_subject("foo")
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher_failure_message(matcher)).to eq('expected the subject to be "foo" but was "bar"')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_subject("bar")
        matcher.matches?(Mail::Message.new(:subject => "bar"))

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected the subject not to be "bar" but was')
      end
    end
  end

  describe "#include_email_with_subject" do

    describe "when regexps are used" do

      it "should match when any email's subject matches passed in regexp" do
        emails = [Mail::Message.new(:subject => "foobar"), Mail::Message.new(:subject => "bazqux")]

        expect(include_email_with_subject(/foo/)).to match(emails)
        expect(include_email_with_subject(/quux/)).not_to match(emails)
      end

      it "should have a helpful description" do
        matcher = include_email_with_subject(/foo/)
        matcher.matches?([])

        expect(matcher.description).to eq('include email with subject matching /foo/')
      end

      it "should offer helpful failing messages" do
        matcher = include_email_with_subject(/foo/)
        matcher.matches?([Mail::Message.new(:subject => "bar")])

        expect(matcher_failure_message(matcher)).to eq('expected at least one email to have a subject matching /foo/, but none did. Subjects were ["bar"]')
      end

      it "should offer helpful negative failing messages" do
        matcher = include_email_with_subject(/foo/)
        matcher.matches?([Mail::Message.new(:subject => "foo")])

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected no email to have a subject matching /foo/ but found at least one. Subjects were ["foo"]')
      end
    end

    describe "when strings are used" do
      it "should match when any email's subject equals passed in subject exactly" do
        emails = [Mail::Message.new(:subject => "foobar"), Mail::Message.new(:subject => "bazqux")]

        expect(include_email_with_subject("foobar")).to match(emails)
        expect(include_email_with_subject("foo")).not_to match(emails)
      end

      it "should have a helpful description" do
        matcher = include_email_with_subject("foo")
        matcher.matches?([])

        expect(matcher.description).to eq('include email with subject of "foo"')
      end

      it "should offer helpful failing messages" do
        matcher = include_email_with_subject("foo")
        matcher.matches?([Mail::Message.new(:subject => "bar")])

        expect(matcher_failure_message(matcher)).to eq('expected at least one email to have the subject "foo" but none did. Subjects were ["bar"]')
      end

      it "should offer helpful negative failing messages" do
        matcher = include_email_with_subject("foo")
        matcher.matches?([Mail::Message.new(:subject => "foo")])

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected no email with the subject "foo" but found at least one. Subjects were ["foo"]')
      end
    end
  end

  describe "#have_body_text" do
    describe "when regexps are used" do
      it "should match when the body matches regexp" do
        email = Mail::Message.new(:body => 'foo bar baz')

        expect(have_body_text(/bar/)).to match(email)
        expect(have_body_text(/qux/)).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_body_text(/qux/)
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher.description).to eq('have body matching /qux/')
      end

      it "should offer helpful failing messages" do
        matcher = have_body_text(/qux/)
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher_failure_message(matcher)).to eq('expected the body to match /qux/, but did not.  Actual body was: "foo bar baz"')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_body_text(/bar/)
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected the body not to match /bar/ but "foo bar baz" does match it.')
      end
    end

    describe "when strings are used" do
      it "should match when the body includes text with symbols" do
        full_name = "Jermain O'Keefe"
        email = Mail::Message.new(body: full_name)

        expect(have_body_text(full_name)).to match(email)
      end

      it "should match when the body includes the text" do
        email = Mail::Message.new(:body => 'foo bar baz')

        expect(have_body_text('bar')).to match(email)
        expect(have_body_text('qux')).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_body_text('qux')
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher.description).to eq('have body including "qux"')
      end

      it "should offer helpful failing messages" do
        matcher = have_body_text('qux')
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher_failure_message(matcher)).to eq('expected the body to contain "qux" but was "foo bar baz"')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_body_text('bar')
        matcher.matches?(Mail::Message.new(:body => 'foo bar baz'))

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected the body not to contain "bar" but was "foo bar baz"')
      end
    end

    describe "when dealing with multipart messages" do
      it "should look at the html part" do
        email = Mail.new do
          text_part do
            body "This is text"
          end
          html_part do
            body "This is html"
          end
        end
        expect(have_body_text(/This is html/)).to match(email)
        expect(have_body_text(/This is text/)).not_to match(email)
      end
    end
  end

  describe "#have_body_text", ".in_html_part" do
    describe 'when html part is definded in mulitpart' do
      it 'should match when the body matches regexp' do
        email = Mail.new do
          html_part do
            body 'This is html'
          end
        end

        expect(have_body_text(/This is html/).in_html_part).to match(email)
      end
    end

    describe 'when text part is definded in mulitpart' do
      it 'should not look at text part' do
        email = Mail.new do
          text_part do
            body 'This is text'
          end
        end

        expect(have_body_text(/This is text/).in_html_part).not_to match(email)
      end
    end

    describe 'when html and text parts are definded in mulitpart' do
      it 'should look at html part' do
        email = Mail.new do
          html_part do
            body 'This is html'
          end
          text_part do
            body 'This is text'
          end
        end

        expect(have_body_text(/This is html/).in_html_part).to match(email)
        expect(have_body_text(/This is text/).in_html_part).not_to match(email)
      end
    end

    describe 'when nothing is defined in mulitpart' do
      it 'should not look at any parts' do
        email = Mail.new(body: 'This is body')

        expect(have_body_text(/This is body/).in_html_part).not_to match(email)
      end
    end
  end

  describe "#have_body_text", ".in_text_part" do
    describe 'when text part is definded in mulitpart' do
      it 'should match when the body matches regexp' do
        email = Mail.new do
          text_part do
            body 'This is text'
          end
        end

        expect(have_body_text(/This is text/).in_text_part).to match(email)
      end
    end

    describe 'when text and html parts are definded in mulitpart' do
      it 'should look at text part' do
        email = Mail.new do
          text_part do
            body 'This is text'
          end

          html_part do
            body 'This is html'
          end
        end

        expect(have_body_text(/This is text/).in_text_part).to match(email)
        expect(have_body_text(/This is html/).in_text_part).not_to match(email)
      end
    end

    describe 'when html part is definded in mulitpart' do
      it 'should not look at html part' do
        email = Mail.new do
          html_part do
            body "This is html"
          end
        end

        expect(have_body_text(/This is html/).in_text_part).not_to match(email)
      end
    end

    describe 'when nothing is defined in mulitpart' do
      it 'should not look at any parts' do
        email = Mail.new(body: 'This is body')

        expect(have_body_text(/This is body/).in_text_part).not_to match(email)
      end
    end
  end
  describe "#have_header" do
    describe "when regexps are used" do
      it "should match when header matches passed in regexp" do
        email = Mail::Message.new(:content_type => "text/html")

        expect(have_header(:content_type, /text/)).to match(email)
        expect(have_header(:foo, /text/)).not_to match(email)
        expect(have_header(:content_type, /bar/)).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_header(:content_type, /bar/)
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        expect(matcher.description).to eq('have header content_type with value matching /bar/')
      end

      it "should offer helpful failing messages" do
        matcher = have_header(:content_type, /bar/)
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        expect(matcher_failure_message(matcher)).to eq('expected the headers to include \'content_type\' with a value matching /bar/ but they were {"content-type"=>"text/html"}')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_header(:content_type, /text/)
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        expect(matcher_failure_message_when_negated(matcher)).to eq('expected the headers not to include \'content_type\' with a value matching /text/ but they were {"content-type"=>"text/html"}')
      end
    end

    describe "when strings are used" do
      it "should match when header equals passed in value exactly" do
        email = Mail::Message.new(:content_type => "text/html")

        expect(have_header(:content_type, 'text/html')).to match(email)
        expect(have_header(:foo, 'text/html')).not_to match(email)
        expect(have_header(:content_type, 'text')).not_to match(email)
      end

      it "should have a helpful description" do
        matcher = have_header(:content_type, 'text')
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        expect(matcher.description).to eq('have header content_type: text')
      end

      it "should offer helpful failing messages" do
        matcher = have_header(:content_type, 'text')
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        expect(matcher_failure_message(matcher)).to eq('expected the headers to include \'content_type: text\' but they were {"content-type"=>"text/html"}')
      end

      it "should offer helpful negative failing messages" do
        matcher = have_header(:content_type, 'text/html')
        matcher.matches?(Mail::Message.new(:content_type => "text/html"))

        matcher_failure_message_when_negated(matcher) == 'expected the headers not to include \'content_type: text/html\' but they were {:content_type=>"text/html"}'
      end
    end
  end
end
