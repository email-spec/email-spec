#Commonly used email steps
#
# To add your own steps make a custom_email_steps.rb
# The provided methods are:
#
# reset_mailer 
# open_last_email
# visit_in_email
# unread_emails_for
# mailbox_for
# current_email
# open_email
# read_emails_for


def current_email_address
  "quentin@example.com" # Replace with your a way to find your current_email. e.g current_user.email
end
# Use this step to reset the e-mail queue within a scenario.
# This is done automatically before each scenario.
Given /^no emails have been sent$/ do
  reset_mailer
end

# Use this step to open the most recently sent e-mail. 
When /^I open the email$/ do
  open_last_email
end

When /^I follow "(.*)" in the email$/ do |link|
  visit_in_email(link)
end

Then /^I should receive (.*) emails?$/ do |amount|
  amount = 1 if amount == "an"
  unread_emails_for(current_email_address).size.should == amount
end

Then /^"([^']*?)" should receive (\d+) emails?$/ do |email, n|
  unread_emails_for(email).size.should == n.to_i 
end

Then /^"([^']*?)" should have (\d+) emails?$/ do |email, n|
  mailbox_for(email).size.should == n.to_i
end

Then /^"([^']*?)" should not receive an email$/ do |email|
  open_email(email).should be_nil
end

Then /^I should see "(.*)" in the subject$/ do |text|
  current_email.subject.should =~ Regexp.new(text)
end

Then /^I should see "(.*)" in the email$/ do |text|
  current_email.body.should =~ Regexp.new(text)
end

When %r{^"([^']*?)" opens? the email with subject "([^']*?)"$} do |email, subject|
  open_email(email, :with_subject => subject)
end

When %r{^"([^']*?)" opens? the email with text "([^']*?)"$} do |email, text|
  open_email(email, :with_text => text)
end


