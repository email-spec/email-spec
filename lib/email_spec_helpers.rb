require 'uri'

module EmailSpec

  module Helpers

    def self.extended(base)
      base.instance_eval do
        @email_spec_hash = {}
        @email_spec_hash[:read_emails] = {}
        @email_spec_hash[:unread_emails] = {}
        @email_spec_hash[:current_emails] = {}
        @email_spec_hash[:current_email] = nil
      end
    end
    
    def reset_mailer
      ActionMailer::Base.deliveries.clear
    end
    
    def open_email(email_address, opts={})
      if opts[:with_subject]
        email = mailbox_for(email_address).find { |m| m.subject =~ Regexp.new(opts[:with_subject]) }
      elsif opts[:with_text]
        email = mailbox_for(email_address).find { |m| m.body =~ Regexp.new(opts[:with_text]) }
      else
        email = mailbox_for(email_address).first
      end
            
      read_emails_for(email_address) << email if email
      
      @email_spec_hash[:current_emails][email_address] = email
      @email_spec_hash[:current_email] = email
    end
    
    def current_email(email_address=nil)
      email_address ? @email_spec_hash[:current_emails][email_address] : @email_spec_hash[:current_email]
    end
    
    def unread_emails_for(email_address)
      mailbox_for(email_address) - read_emails_for(email_address)
    end
    
    def read_emails_for(email_address)
      @email_spec_hash[:read_emails][email_address] ||= []
    end
    
    def mailbox_for(email)
      ActionMailer::Base.deliveries.select { |m| m.to.include?(email) }
    end
    
    def parse_email_for_link(mail, link_text)
      if mail.body.include?(link_text)
        if link_text =~ %r{^/.*$}
          # if it's an explicit link
          link_text
        elsif mail.body =~ %r{<a[^>]*href=['"]?([^'"]*)['"]?[^>]*?>[^<]*?#{link_text}[^<]*?</a>}
          # if it's an anchor tag
          URI.parse($~[1]).path
        end
      end
    end
  end
end
