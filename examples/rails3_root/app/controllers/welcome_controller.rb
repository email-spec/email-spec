class WelcomeController < ApplicationController
  def signup
    UserMailer.signup(params['Email'], params['Name']).deliver_now
  end

  def confirm
  end

  def newsletter
    Delayed::Job.enqueue(NotifierJob.new(:newsletter, params['Email'],
                                         params['Name']))
  end

  def attachments
    UserMailer.email_with_attachment(params['Email'], params['Name'])
              .deliver_now
  end
end
