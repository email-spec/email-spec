require 'spec_helper'

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
  end
end
