class WelcomeController < ApplicationController
  def signup
    UserMailer.signup(params['Email'], params['Name']).deliver
  end

  def confirm
  end

  def newsletter
    UserMailer.signup(params['Email'], params['Name']).send_later(:deliver)
  end

  def attachments
    UserMailer.attachments_mail(params['Email'], params['Name']).deliver
  end
end
