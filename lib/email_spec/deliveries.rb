module EmailSpec
  module MailerDeliveries
    def all_emails
      deliveries
    end

    def last_email_sent
      deliveries.last || raise("No email has been sent!")
    end

    def reset_mailer
      if defined?(ActionMailer) && ActionMailer::Base.delivery_method == :cache
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
      if ActionMailer::Base.delivery_method == :cache
        mailer.cached_deliveries
      else
        mailer.deliveries
      end
    end
  end

  module ARMailerDeliveries
    def all_emails
      Email.all.map{ |email| parse_to_mail(email) }
    end

    def last_email_sent
      if email = Email.last
        parse_to_mail(email)
      else
        raise("No email has been sent!")
      end
    end

    def reset_mailer
      Email.delete_all
    end

    def mailbox_for(address)
      Email.all.select { |email| email.destinations.include?(address) }.map{ |email| parse_to_mail(email) }
    end

    def parse_to_mail(email)
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

  module Deliveries
    if defined?(Pony)
      def deliveries; Pony::deliveries ; end
      include EmailSpec::MailerDeliveries
    else
      ActiveSupport.on_load(:action_mailer) do
        if delivery_method == :activerecord
          ::EmailSpec::Helpers.include EmailSpec::ARMailerDeliveries
        else
          ::EmailSpec::Deliveries.module_eval do
            def mailer
              ActionMailer::Base
            end
          end
          ::EmailSpec::Helpers.include ::EmailSpec::MailerDeliveries
        end
      end
    end
  end
end
