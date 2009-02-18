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
      address = AddressConverter.instance.convert(address)
      ActionMailer::Base.deliveries.select { |m| m.to.include?(address) }
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
      address = AddressConverter.instance.convert(address)
      Email.all.select { |email| email.to.include?(address) }.map{ |email| parse_to_tmail(email) }
    end
    
    def parse_to_tmail(email)
      TMail::Mail.parse(email.mail)
    end    
  end
  
  module Deliveries
    if ActionMailer::Base.delivery_method == :activerecord
      include EmailSpec::ARMailerDeliveries
    else
      include EmailSpec::TestDeliveries
    end    
  end
end