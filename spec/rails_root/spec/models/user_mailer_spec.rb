require File.dirname(__FILE__) + '/../spec_helper'

describe "Signup Email" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ActionController::UrlWriter

  before(:all) do
    @email = UserMailer.create_signup("jojo@yahoo.com", "Jojo Binks")
  end
  
  it "should be set to be delivered to the email passed in" do
    @email.should deliver_to("jojo@yahoo.com")
  end
  
  it "should contain the user's message in the mail body" do
    @email.body.should have_text(/Jojo Binks/)
  end

  it "should contain a link to the confirmation link" do
    @email.body.should have_text(/#{confirm_account_url}/)
  end
  
  it "should have the correct subject" do
    @email.subject.should =~ /Account confirmation/
  end
  
  
end

