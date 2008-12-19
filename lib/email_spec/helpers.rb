require 'uri'

module EmailSpec

  module Helpers
    
    def reset_mailer
      ActionMailer::Base.deliveries.clear
    end


    def visit_in_email(link_text)
      visit(parse_email_for_link(current_email, link_text))
    end
    
    def open_email(address, opts={})
      email = find_email!(address, opts) 
      email.should_not be_nil
      set_current_email(email)
    end

    def open_last_email
      email = ActionMailer::Base.deliveries.last
      email.should_not be_nil
      set_current_email(email)
    end
    
    def current_email(address=nil)
      email = address ? email_spec_hash[:current_emails][address] : email_spec_hash[:current_email]
      raise Spec::Expectations::ExpectationNotMetError, "Expected an open email but none was found. Did you forget to call open_email?" unless email  
      email
    end
    
    def unread_emails_for(address)
      mailbox_for(address) - read_emails_for(address)
    end
    
    def read_emails_for(address)
      email_spec_hash[:read_emails][address] ||= []
    end
    
    def mailbox_for(address)
      ActionMailer::Base.deliveries.select { |m| m.to.include?(address) }
    end
    
    def find_email(address, opts={})
     if opts[:with_subject]
        email = mailbox_for(address).find { |m| m.subject =~ Regexp.new(opts[:with_subject]) }
      elsif opts[:with_text]
        email = mailbox_for(address).find { |m| m.body =~ Regexp.new(opts[:with_text]) }
      else
        email = mailbox_for(address).first
      end
    end

    private

    def email_spec_hash
      @email_spec_hash ||= {:read_emails => {}, :unread_emails => {}, :current_emails => {}, :current_email => nil}
    end
	
    def find_email!(address, opts={})
      email = find_email(address, opts)
      if email.nil?
	error = "#{opts.keys.first.to_s.humanize unless opts.empty?} #{('"' + opts.values.first.to_s.humanize + '"') unless opts.empty?}"
	raise Spec::Expectations::ExpectationNotMetError, "Could not find email #{error}. \n Found the following emails:\n\n #{ActionMailer::Base.deliveries.to_s}"
       end
      email
    end

    def set_current_email(email)
      return unless email
      read_emails_for(email.to) << email      
      email_spec_hash[:current_emails][email.to] = email
      email_spec_hash[:current_email] = email
    end
    
    def parse_email_for_link(email, link_text)
      email.body.should include_text(link_text)
      if link_text =~ %r{^/.*$}
	# if it's an explicit link
	link_text
      elsif email.body =~ %r{<a[^>]*href=['"]?([^'"]*)['"]?[^>]*?>[^<]*?#{link_text}[^<]*?</a>}
	# if it's an anchor tag
	URI.split($~[1])[5..-1].compact!.join("?").gsub("&amp;", "&")
	# sub correct ampersand after rails switches it (http://dev.rubyonrails.org/ticket/4002) 
	# TODO: outsource this kind of parsing to webrat or someone else
      end
    end
  end
end
