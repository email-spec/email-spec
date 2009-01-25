
When /^I submit my registration information$/ do
  fill_in "Name", :with => "Jojo Binks"
  fill_in "Email", :with => "jojo@thebinks.com"
  click_button
end

Then /^I should receive an email with a link to a confirmation page$/ do
  unread_emails_for("jojo@thebinks.com").size.should == 1 
  
  # this call will store the email and you can access it with current_email
  open_last_email_for("jojo@thebinks.com")
  current_email.should have_subject(/Account confirmation/)
  current_email.should have_body_text("Jojo Binks")

  click_email_link_matching /confirm/
  response.should include_text("Confirm your new account")
  
end

