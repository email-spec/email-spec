require 'spec_helper'
require 'active_support'

describe EmailSpec::MailExt do
  describe "#default_part" do
    it "prefers html_part over text_part" do
      email = Mail.new do
        text_part { body "This is text" }
        html_part { body "This is html" }
      end

      expect(email.default_part.body.to_s).to eq("This is html")
    end

    it "returns text_part if html_part not available" do
      email = Mail.new do
        text_part { body "This is text" }
      end

      expect(email.default_part.body.to_s).to eq("This is text")
    end

    it "returns the email if not multi-part" do
      email = Mail.new { body "This is the body" }
      expect(email.default_part.body.to_s).to eq("This is the body")
    end
  end

  describe "#default_part_body" do
    it "returns default_part.body" do
      email = Mail.new(:body => "hi")
      expect(email.default_part.body).to eq(email.default_part_body)
    end

    it "compatible with ActiveSupport::SafeBuffer" do
      email = Mail.new(:body => ActiveSupport::SafeBuffer.new("bacon &amp; pancake"))
      expect(email.default_part_body).to eq ("bacon & pancake")
    end

    it "decodes parts before return" do
      email = Mail.new(:body => "hello\r\nquoted-printable")
      email.content_transfer_encoding = 'quoted-printable'
      expect(email.encoded).to include("hello=0D\nquoted-printable")
      expect(email.default_part_body).to eq("hello\r\nquoted-printable")
    end
  end

  describe "#html" do
    it "returns the html part body" do
      email = Mail.new do
        html_part { body "This is html" }
      end

      expect(email.html).to eq("This is html")
    end

    it "returns a String" do
      email = Mail.new do
        html_part { body "This is html" }
      end

      expect(email.html).to be_a(String)
    end

    it "returns nil for mail with no html part" do
      email = Mail.new
      expect(email.html).to be_nil
    end
  end
end
