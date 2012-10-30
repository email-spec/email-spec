module EmailSpec
  module Matchers
    class ReplyTo
      def initialize(email)
        @expected_reply_to = Mail::ReplyToField.new(email).addrs.first
      end

      def description
        "have reply to as #{@expected_reply_to.address}"
      end

      def matches?(email)
        @email = email
        @actual_reply_to = (email.reply_to || []).first
        !@actual_reply_to.nil? &&
          @actual_reply_to == @expected_reply_to.address
      end

      def failure_message
        "expected #{@email.inspect} to reply to #{@expected_reply_to.address.inspect}, but it replied to #{@actual_reply_to.inspect}"
      end

      def negative_failure_message
        "expected #{@email.inspect} not to deliver to #{@expected_reply_to.address.inspect}, but it did"
      end
    end

    def reply_to(email)
      ReplyTo.new(email)
    end

    alias :have_reply_to :reply_to

    class DeliverTo
      def initialize(expected_email_addresses_or_objects_that_respond_to_email)
        emails = expected_email_addresses_or_objects_that_respond_to_email.map do |email_or_object|
          email_or_object.kind_of?(String) ? email_or_object : email_or_object.email
        end

        @expected_recipients = Mail::ToField.new(emails).addrs.map(&:to_s).sort
      end

      def description
        "be delivered to #{@expected_recipients.inspect}"
      end

      def matches?(email)
        @email = email
        @actual_recipients = (email.header[:to].addrs || []).map(&:to_s).sort
        @actual_recipients == @expected_recipients
      end

      def failure_message
        "expected #{@email.inspect} to deliver to #{@expected_recipients.inspect}, but it delivered to #{@actual_recipients.inspect}"
      end

      def negative_failure_message
        "expected #{@email.inspect} not to deliver to #{@expected_recipients.inspect}, but it did"
      end
    end

    def deliver_to(*expected_email_addresses_or_objects_that_respond_to_email)
      DeliverTo.new(expected_email_addresses_or_objects_that_respond_to_email.flatten)
    end

    alias :be_delivered_to :deliver_to

    class DeliverFrom

      def initialize(email)
        @expected_sender = Mail::FromField.new(email).addrs.first
      end

      def description
        "be delivered from #{@expected_sender}"
      end

      def matches?(email)
        @email = email
        @actual_sender = (email.header[:from].addrs || []).first

        !@actual_sender.nil? &&
          @actual_sender.to_s == @expected_sender.to_s
      end

      def failure_message
        %(expected #{@email.inspect} to deliver from "#{@expected_sender.to_s}", but it delivered from "#{@actual_sender.to_s}")
      end

      def negative_failure_message
        %(expected #{@email.inspect} not to deliver from "#{@expected_sender.to_s}", but it did)
      end
    end

    def deliver_from(email)
      DeliverFrom.new(email)
    end

    alias :be_delivered_from :deliver_from

    class BccTo

      def initialize(expected_email_addresses_or_objects_that_respond_to_email)
        emails = expected_email_addresses_or_objects_that_respond_to_email.map do |email_or_object|
          email_or_object.kind_of?(String) ? email_or_object : email_or_object.email
        end

        @expected_email_addresses = emails.sort
      end

      def description
        "be bcc'd to #{@expected_email_addresses.inspect}"
      end

      def matches?(email)
        @email = email
        @actual_recipients = (Array(email.bcc) || []).sort
        @actual_recipients == @expected_email_addresses
      end

      def failure_message
        "expected #{@email.inspect} to bcc to #{@expected_email_addresses.inspect}, but it was bcc'd to #{@actual_recipients.inspect}"
      end

      def negative_failure_message
        "expected #{@email.inspect} not to bcc to #{@expected_email_addresses.inspect}, but it did"
      end
    end

    def bcc_to(*expected_email_addresses_or_objects_that_respond_to_email)
      BccTo.new(expected_email_addresses_or_objects_that_respond_to_email.flatten)
    end

    class CcTo

      def initialize(expected_email_addresses_or_objects_that_respond_to_email)
        emails = expected_email_addresses_or_objects_that_respond_to_email.map do |email_or_object|
          email_or_object.kind_of?(String) ? email_or_object : email_or_object.email
        end

        @expected_email_addresses = emails.sort
      end

      def description
        "be cc'd to #{@expected_email_addresses.inspect}"
      end

      def matches?(email)
        @email = email
        @actual_recipients = (Array(email.cc) || []).sort
        @actual_recipients == @expected_email_addresses
      end

      def failure_message
        "expected #{@email.inspect} to cc to #{@expected_email_addresses.inspect}, but it was cc'd to #{@actual_recipients.inspect}"
      end

      def negative_failure_message
        "expected #{@email.inspect} not to cc to #{@expected_email_addresses.inspect}, but it did"
      end
    end

    def cc_to(*expected_email_addresses_or_objects_that_respond_to_email)
      CcTo.new(expected_email_addresses_or_objects_that_respond_to_email.flatten)
    end

    class HaveSubject

      def initialize(subject)
        @expected_subject = subject
      end

      def description
        if @expected_subject.is_a?(String)
          "have subject of #{@expected_subject.inspect}"
        else
          "have subject matching #{@expected_subject.inspect}"
        end
      end

      def matches?(email)
        @given_subject = email.subject
        if @expected_subject.is_a?(String)
          @given_subject == @expected_subject
        else
          !!(@given_subject =~ @expected_subject)
        end
      end

      def failure_message
        if @expected_subject.is_a?(String)
          "expected the subject to be #{@expected_subject.inspect} but was #{@given_subject.inspect}"
        else
          "expected the subject to match #{@expected_subject.inspect}, but did not.  Actual subject was: #{@given_subject.inspect}"
        end
      end

      def negative_failure_message
        if @expected_subject.is_a?(String)
          "expected the subject not to be #{@expected_subject.inspect} but was"
        else
          "expected the subject not to match #{@expected_subject.inspect} but #{@given_subject.inspect} does match it."
        end
      end
    end

    def have_subject(subject)
      HaveSubject.new(subject)
    end

    class IncludeEmailWithSubject

      def initialize(subject)
        @expected_subject = subject
      end

      def description
        if @expected_subject.is_a?(String)
          "include email with subject of #{@expected_subject.inspect}"
        else
          "include email with subject matching #{@expected_subject.inspect}"
        end
      end

      def matches?(emails)
        @given_emails = emails
        if @expected_subject.is_a?(String)
          @given_emails.map(&:subject).include?(@expected_subject)
        else
          !!(@given_emails.any?{ |mail| mail.subject =~ @expected_subject })
        end
      end

      def failure_message
        if @expected_subject.is_a?(String)
          "expected at least one email to have the subject #{@expected_subject.inspect} but none did. Subjects were #{@given_emails.map(&:subject).inspect}"
        else
          "expected at least one email to have a subject matching #{@expected_subject.inspect}, but none did. Subjects were #{@given_emails.map(&:subject).inspect}"
        end
      end

      def negative_failure_message
        if @expected_subject.is_a?(String)
          "expected no email with the subject #{@expected_subject.inspect} but found at least one. Subjects were #{@given_emails.map(&:subject).inspect}"
        else
          "expected no email to have a subject matching #{@expected_subject.inspect} but found at least one. Subjects were #{@given_emails.map(&:subject).inspect}"
        end
      end
    end

    def include_email_with_subject(*emails)
      IncludeEmailWithSubject.new(emails.flatten.first)
    end

    class HaveBodyText

      def initialize(text)
        @expected_text = text
      end

      def description
        if @expected_text.is_a?(String)
          "have body including #{@expected_text.inspect}"
        else
          "have body matching #{@expected_text.inspect}"
        end
      end

      def matches?(email)
        if @expected_text.is_a?(String)
          @given_text = email.default_part_body.to_s.gsub(/\s+/, " ")
          @expected_text = @expected_text.gsub(/\s+/, " ")
          @given_text.include?(@expected_text)
        else
          @given_text = email.default_part_body.to_s
          !!(@given_text =~ @expected_text)
        end
      end

      def failure_message
        if @expected_text.is_a?(String)
          "expected the body to contain #{@expected_text.inspect} but was #{@given_text.inspect}"
        else
          "expected the body to match #{@expected_text.inspect}, but did not.  Actual body was: #{@given_text.inspect}"
        end
      end

      def negative_failure_message
        if @expected_text.is_a?(String)
          "expected the body not to contain #{@expected_text.inspect} but was #{@given_text.inspect}"
        else
          "expected the body not to match #{@expected_text.inspect} but #{@given_text.inspect} does match it."
        end
      end
    end

    def have_body_text(text)
      HaveBodyText.new(text)
    end

    class HaveHeader

      def initialize(name, value)
        @expected_name, @expected_value = name, value
      end

      def description
        if @expected_value.is_a?(String)
          "have header #{@expected_name}: #{@expected_value}"
        else
          "have header #{@expected_name} with value matching #{@expected_value.inspect}"
        end
      end

      def matches?(email)
        @given_header = email.header

        if @expected_value.is_a?(String)
          @given_header[@expected_name].to_s == @expected_value
        else
          @given_header[@expected_name].to_s =~ @expected_value
        end      end

      def failure_message
        if @expected_value.is_a?(String)
          "expected the headers to include '#{@expected_name}: #{@expected_value}' but they were #{mail_headers_hash(@given_header).inspect}"
        else
          "expected the headers to include '#{@expected_name}' with a value matching #{@expected_value.inspect} but they were #{mail_headers_hash(@given_header).inspect}"
        end
      end

      def negative_failure_message
        if @expected_value.is_a?(String)
          "expected the headers not to include '#{@expected_name}: #{@expected_value}' but they were #{mail_headers_hash(@given_header).inspect}"
        else
          "expected the headers not to include '#{@expected_name}' with a value matching #{@expected_value.inspect} but they were #{mail_headers_hash(@given_header).inspect}"
        end
      end

      def mail_headers_hash(email_headers)
        email_headers.fields.inject({}) { |hash, field| hash[field.field.class::FIELD_NAME] = field.to_s; hash }
      end
    end

    def have_header(name, value)
      HaveHeader.new(name, value)
    end

    def self.included base
      if base.respond_to? :register_matcher
        instance_methods.each do |name|
          base.register_matcher name, name
        end
      end
    end
  end
end
