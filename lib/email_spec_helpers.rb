module EmailSpec
  module Helpers
    
    def reset_mailer
      ActionMailer::Base.deliveries.clear
    end

    def emails_sent_to(email)
      if email.is_a? Array
        email_array = email.sort
        ActionMailer::Base.deliveries.select { |m| m.to.sort == email_array }
      else
        ActionMailer::Base.deliveries.select { |m| m.to.include?(email) }
      end
    end
    
  end
end