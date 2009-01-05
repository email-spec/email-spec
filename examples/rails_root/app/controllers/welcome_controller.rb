class WelcomeController < ApplicationController
  def signup
    UserMailer.deliver_signup(params['Email'], params['Name'])
  end

  def confirm
  end

end
