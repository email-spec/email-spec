module EmailSpec
  class TestObserver
    def delivered_email(message)
      ActionMailer::Base.deliveries << message
    end
  end
end