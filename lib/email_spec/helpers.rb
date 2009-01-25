require 'uri'

module EmailSpec

  module Helpers
    include Deliveries
    
    def visit_in_email(link_text)
      visit(parse_email_for_link(current_email, link_text))
    end
    
    def click_email_link_matching(regex, email = current_email)
      url = links_in_email(email).detect { |link| link =~ regex }
      raise "No link found matching #{regex.inspect} in #{email.body}" unless url
      request_uri = URI::parse(url).request_uri
      visit request_uri
    end
    
    def click_first_link_in_email(email = current_email)
      link = links_in_email(email).first
      request_uri = URI::parse(link).request_uri
      visit request_uri
    end
    
    def open_email(address, opts={})
      set_current_email(find_email!(address, opts))
    end
    
    alias_method :open_email_for, :open_email

    def open_last_email
      set_current_email(last_email_sent)
    end

    def open_last_email_for(address)
      set_current_email(mailbox_for(address).last)
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
        raise Spec::Expectations::ExpectationNotMetError, "Could not find email #{error}. \n Found the following emails:\n\n #{all_emails.to_s}"
       end
      email
    end

    def set_current_email(email)
      return unless email
      read_emails_for(email.to) << email      
      email_spec_hash[:current_emails][email.to] = email
      email_spec_hash[:current_email] = email
    end
    
    def links_in_email(email)
      URI.extract(email.body, ['http', 'https'])
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
