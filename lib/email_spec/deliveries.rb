module EmailSpec
  module TestDeliveries
    def all_emails
      ActionMailer::Base.deliveries
    end

    def last_email_sent
      ActionMailer::Base.deliveries.last || raise("No email has been sent!")
    end

    def reset_mailer
      ActionMailer::Base.deliveries.clear
    end

    def mailbox_for(address)
      ActionMailer::Base.deliveries.select { |m| m.to.include?(address) || (m.bcc && m.bcc.include?(address)) || (m.cc && m.cc.include?(address)) }
    end
  end

  module ARMailerDeliveries
    def all_emails
      Email.all.map{ |email| parse_to_tmail(email) }
    end

    def last_email_sent
      if email = Email.last
        TMail::Mail.parse(email.mail)
      else
        raise("No email has been sent!")
      end
    end

    def reset_mailer
      Email.delete_all
    end

    def mailbox_for(address)
      Email.all.select { |email| email.to.include?(address) || email.bcc.include?(address) || email.cc.include?(address) }.map{ |email| parse_to_tmail(email) }
    end

    def parse_to_tmail(email)
      TMail::Mail.parse(email.mail)
    end
  end

  module PonyDeliveries
    def all_emails
      Pony.deliveries
    end

    def last_email_sent
      Pony.deliveries.last || raise("No email has been sent!")
    end

    def reset_mail
      Pony.deliveries.clear
    end

    def mailbox_for(address)
      Pony.deliveries.select { |m| m.to.include?(address) || (m.bcc && m.bcc.include?(address)) || (m.cc && m.cc.include?(address)) }
    end
  end

  module Deliveries
    if defined?(Pony)
      module ::Pony
        def self.deliveries
          @deliveries ||= []
        end

        def self.mail(options)
          deliveries << build_tmail(options)
        end
      end

      include EmailSpec::PonyDeliveries
    elsif ActionMailer::Base.delivery_method == :activerecord
      include EmailSpec::ARMailerDeliveries
    else
      include EmailSpec::TestDeliveries
    end
  end
end

