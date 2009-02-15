Given "I am a real person wanting to sign up for an account" do
  # no-op.. for documentation purposes only!
end

When /^I submit my registration information$/ do
  fill_in "Name", :with => valid_user_attributes[:name]
  fill_in "Email", :with => valid_user_attributes[:email]
  click_button
end

Then /^I should receive an email with a link to a confirmation page$/ do
  unread_emails_for(valid_user_attributes[:email]).size.should == 1 
  
  # this call will store the email and you can access it with current_email
  open_last_email_for(valid_user_attributes[:email])
  current_email.should have_subject(/Account confirmation/)
  current_email.should have_body_text(valid_user_attributes[:name])

  click_email_link_matching /confirm/
  response.should include_text("Confirm your new account")
  
end

