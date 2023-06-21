module EmailSpec
  module Deliveries
    def all_emails
      deliveries
    end

    def last_email_sent
      deliveries.last || raise("No email has been sent!")
    end

    def reset_mailer
      if defined?(ActionMailer) && ActionMailer::Base.delivery_method == :activerecord
        Email.delete_all
      elsif defined?(ActionMailer) && ActionMailer::Base.delivery_method == :cache
        mailer.clear_cache
      else
        deliveries.clear
      end
    end

    def mailbox_for(address)
      deliveries.select { |email| email.destinations.include?(address) }
    end

    protected

    def deliveries
      if defined?(Pony)
        Pony.deliveries
      elsif ActionMailer::Base.delivery_method == :activerecord
        Email.all.map { |email| parse_ar_to_mail(email) }
      elsif ActionMailer::Base.delivery_method == :cache
        mailer.cached_deliveries
      else
        mailer.deliveries
      end
    end

    def mailer
      ActionMailer::Base
    end

    def parse_ar_to_mail(email)
      Mail.read(email.mail)
    end
  end

  if defined?(Pony)
    module ::Pony
      def self.deliveries
        @deliveries ||= []
      end

      def self.mail(options)
        deliveries << build_mail(options)
      end
    end
  end
end
