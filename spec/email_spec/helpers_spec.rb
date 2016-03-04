require File.dirname(__FILE__) + '/../spec_helper'

describe EmailSpec::Helpers do
  include EmailSpec::Helpers

  describe "#visit_in_email" do
    it "visits the link in the email" do
      @to = "jimmy_bean@yahoo.com"
      @body = "<a href='/hello'>Hello!</a>"
      @email = Mail::Message.new(:to => @to, :from => "foo@bar.com", :body => @body)
      allow(self).to receive(:mailbox_for).with(@to).and_return([@email])
      expect(open_email(@to, :from => "foo@bar.com")).to eq(@email)

      expect do
        expect(self).to(receive(:visit).with('/hello'))
        visit_in_email("Hello!")
      end.not_to raise_error
    end

    it "raises an exception when an email is not found" do
      expect do
        visit_in_email("Hello!", 'jon@example.com')
      end.to raise_error(EmailSpec::CouldNotFindEmailError)
    end
  end

  describe "#parse_email_for_link" do
    it "properly finds links with text" do
      email = Mail.new(:body =>  %(<a href="/path/to/page">Click Here</a>))
      expect(parse_email_for_link(email, "Click Here")).to eq("/path/to/page")
    end

    it "properly finds links with text surrounded by tags" do
      email = Mail.new(:body =>  %(<a href="/path/to/page"><strong>Click Here</strong></a>))
      expect(parse_email_for_link(email, "Click Here")).to eq("/path/to/page")
    end

    it "recognizes img alt properties as text" do
      email = Mail.new(:body => %(<a href="/path/to/page"><img src="http://host.com/images/image.gif" alt="an image" /></a>))
      expect(parse_email_for_link(email, "an image")).to eq("/path/to/page")
    end

    it "causes a spec to fail if the body doesn't contain the text specified to click" do
      email = Mail.new(:body => "")
      expect { parse_email_for_link(email, "non-existent text") }.to raise_error(  RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe "#set_current_email" do
    it "should cope with a nil email" do
      expect do
        out = set_current_email(nil)
        expect(out).to be_nil
        expect(email_spec_hash[:current_email]).to be_nil
      end.not_to raise_error
    end

    it "should cope with a real email" do
      email = Mail.new
      expect do
        out = set_current_email(email)
        expect(out).to eq(email)
        expect(email_spec_hash[:current_email]).to eq(email)
      end.not_to raise_error
    end

    shared_examples_for 'something that sets the current email for recipients' do
      before do
        @email = Mail.new(@recipient_type => 'dave@example.com')
      end

      it "should record that the email has been read for that recipient" do
        set_current_email(@email)
        expect(email_spec_hash[:read_emails]['dave@example.com']).to include(@email)
      end

      it "should record that the email has been read for all the recipient of that type" do
        @email.send(@recipient_type) << 'dave_2@example.com'
        set_current_email(@email)
        expect(email_spec_hash[:read_emails]['dave@example.com']).to include(@email)
        expect(email_spec_hash[:read_emails]['dave_2@example.com']).to include(@email)
      end

      it "should record that the email is the current email for the recipient" do
        set_current_email(@email)
        expect(email_spec_hash[:current_emails]['dave@example.com']).to eq(@email)
      end

      it "should record that the email is the current email for all the recipients of that type" do
        @email.send(@recipient_type) << 'dave_2@example.com'
        set_current_email(@email)
        expect(email_spec_hash[:current_emails]['dave@example.com']).to eq(@email)
        expect(email_spec_hash[:current_emails]['dave_2@example.com']).to eq(@email)
      end

      it "should overwrite current email for the recipient with this one" do
        other_mail = Mail.new
        email_spec_hash[:current_emails]['dave@example.com'] = other_mail
        set_current_email(@email)
        expect(email_spec_hash[:current_emails]['dave@example.com']).to eq(@email)
      end

      it "should overwrite the current email for all the recipients of that type" do
        other_mail = Mail.new
        email_spec_hash[:current_emails]['dave@example.com'] = other_mail
        email_spec_hash[:current_emails]['dave_2@example.com'] = other_mail
        @email.send(@recipient_type) << 'dave_2@example.com'
        set_current_email(@email)
        expect(email_spec_hash[:current_emails]['dave@example.com']).to eq(@email)
        expect(email_spec_hash[:current_emails]['dave_2@example.com']).to eq(@email)
      end

      it "should not complain when the email has recipients of that type" do
        @email.send(:"#{@recipient_type}=", nil)
        expect { set_current_email(@email) }.not_to raise_error
      end
    end

    describe "#request_uri(link)" do
      context "without query and anchor" do
        it "returns the path" do
          expect(request_uri('http://www.path.se/to/page')).to eq('/to/page')
        end
      end

      context "with query and anchor" do
        it "returns the path and query and the anchor" do
          expect(request_uri('http://www.path.se/to/page?q=adam#task')).to eq('/to/page?q=adam#task')
        end
      end

      context "with anchor" do
        it "returns the path and query and the anchor" do
          expect(request_uri('http://www.path.se/to/page#task')).to eq('/to/page#task')
        end
      end
    end

    describe 'for mails with recipients in the to address' do
      before do
        @recipient_type = :to
      end

      it_should_behave_like 'something that sets the current email for recipients'
    end

    describe 'for mails with recipients in the cc address' do
      before do
        @recipient_type = :cc
      end

      it_should_behave_like 'something that sets the current email for recipients'
    end

    describe 'for mails with recipients in the bcc address' do
      before do
        @recipient_type = :bcc
      end

      it_should_behave_like 'something that sets the current email for recipients'
    end
  end

  describe '#open_email' do

    describe 'from' do

      before do
        @to = "jimmy_bean@yahoo.com"
        @email = Mail::Message.new(:to => @to, :from => "foo@bar.com")
        allow(self).to receive(:mailbox_for).with(@to).and_return([@email])
      end

      it "should open the email from someone" do
        expect(open_email(@to, :from => "foo@bar.com")).to eq(@email)
      end

    end

    describe 'with subject' do
      shared_examples_for 'something that opens the email with subject' do
        before do
          @to = "jimmy_bean@yahoo.com"
          @email = Mail::Message.new(:to => @to, :subject => @subject)
          allow(self).to receive(:mailbox_for).with(@to).and_return([@email])
        end

        it "should open the email with subject" do
          expect(open_email(@to, :with_subject => @expected)).to eq(@email)
        end
      end

      describe 'simple string subject' do
        before do
          @subject  = 'This is a simple subject'
          @expected = 'a simple'
        end

        it_should_behave_like 'something that opens the email with subject'
      end

      describe 'string with regex sensitive characters' do
        before do
          @subject  = '[app name] Contains regex characters?'
          @expected = 'regex characters?'
        end

        it_should_behave_like 'something that opens the email with subject'
      end

      describe 'regular expression' do
        before do
          @subject = "This is a simple subject"
          @expected = /a simple/
        end

        it_should_behave_like 'something that opens the email with subject'
      end
    end

    describe 'with text' do
      shared_examples_for 'something that opens the email with text' do
        before do
          @to = "jimmy_bean@yahoo.com"
          @email = Mail::Message.new(:to => @to, :body => @body)
          allow(self).to receive(:mailbox_for).with(@to).and_return([@email])
        end

        it "should open the email with text" do
          expect(open_email(@to, :with_text => @text)).to eq(@email)
        end
      end

      describe 'simple string text' do
        before do
          @body = 'This is an email body that is very simple'
          @text = 'email body'
        end

        it_should_behave_like 'something that opens the email with text'
      end

      describe 'string with regex sensitive characters' do
        before do
          @body = 'This is an email body. It contains some [regex] characters?'
          @text = '[regex] characters?'
        end

        it_should_behave_like 'something that opens the email with text'
      end

      describe 'regular expression' do
        before do
          @body = 'This is an email body.'
          @text = /an\ email/
        end

        it_should_behave_like 'something that opens the email with text'
      end
    end

    describe "when the email isn't found" do
      it "includes the mailbox that was looked in when an address was provided" do
        @email_address = "foo@bar.com"
        expect { open_email(@email_address, :with_subject => "baz") }.to raise_error(EmailSpec::CouldNotFindEmailError) { |error| expect(error.message).to include(@email_address) }
      end

      it "includes a warning that no mailboxes were searched when no address was provided" do
        allow(subject).to receive(:last_email_address).and_return nil
        expect { open_email(nil, :with_subject => "baz") }.to raise_error(EmailSpec::NoEmailAddressProvided) { |error| expect(error.message).to eq("No email address has been provided. Make sure current_email_address is returning something.") }
      end

      describe "search by with_subject" do
        before do
          @email_subject = "Subject of 'Nonexistent Email'"
          begin
            open_email("foo@bar.com", :with_subject => @email_subject)
          rescue EmailSpec::CouldNotFindEmailError => e
            @error = e
          end

          expect(@error).not_to be_nil, "expected an error to get thrown so we could test against it, but didn't catch one"
        end

        it "includes the subject that wasn't found in the error message" do
          expect(@error.message).to include(@email_subject)
        end

        it "includes 'with subject' in the error message" do
          expect(@error.message).to include('with subject')
        end
      end

      describe "search by with_text" do
        before do
          @email_text = "This is a line of text from a 'Nonexistent Email'."
          begin
            open_email("foo@bar.com", :with_text => @email_text)
          rescue EmailSpec::CouldNotFindEmailError => e
            @error = e
          end

          expect(@error).not_to be_nil, "expected an error to get thrown so we could test against it, but didn't catch one"
        end

        it "includes the text that wasn't found in the error message" do
          expect(@error.message).to include(@email_text)
        end

        it "includes 'with text' in the error message" do
          expect(@error.message).to include('with text')
        end
      end
    end
  end
end
