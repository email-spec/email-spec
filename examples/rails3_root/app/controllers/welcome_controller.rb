class WelcomeController < ApplicationController
  def signup
    UserMailer.signup(params['Email'], params['Name']).deliver
  end

  def confirm
  end

  def newsletter
    UserMailer.sign_up(params['Email'], params['Name']).send_later(:deliver)
  end

  def attachments
    UserMailer.attachments(params['Email'], params['Name']).deliver
  end
end
