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

    def visit_in_email(link_text)
      visit(parse_email_for_link(current_email, link_text))
    end
    
    def open_email(email_address, opts={})
      email = find_email(email_address, opts) 
      set_current_email(email)
    end

    def open_last_email
      email = ActionMailer::Base.deliveries.last
      raise "Last email was nil" unless email #TODO: fix
      set_current_email(email)
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
    
    def mailbox_for(email_address)
      ActionMailer::Base.deliveries.select { |m| m.to.include?(email_address) }
    end
    
    private

    def set_current_email(email=nil)
      return unless email
      read_emails_for(email.to) << email      
      @email_spec_hash[:current_emails][email.to] = email
      @email_spec_hash[:current_email] = email
    end
    
    def find_email(email_address, opts)
     if opts[:with_subject]
        email = mailbox_for(email_address).find { |m| m.subject =~ Regexp.new(opts[:with_subject]) }
      elsif opts[:with_text]
        email = mailbox_for(email_address).find { |m| m.body =~ Regexp.new(opts[:with_text]) }
      else
        email = mailbox_for(email_address).first
      end
    end

    def parse_email_for_link(mail, link_text)
      if mail.body.include?(link_text)
        if link_text =~ %r{^/.*$}
          # if it's an explicit link
          link_text
        elsif mail.body =~ %r{<a[^>]*href=['"]?([^'"]*)['"]?[^>]*?>[^<]*?#{link_text}[^<]*?</a>}
          # if it's an anchor tag
          URI.split($~[1])[5..-1].compact!.join("?").gsub("&amp;", "&")
	  # sub correct ampersand after rails switches it (http://dev.rubyonrails.org/ticket/4002) 
	  # TODO: outsource this kind of parsing to webrat or someone else
        end
      end
    end
  end
end
