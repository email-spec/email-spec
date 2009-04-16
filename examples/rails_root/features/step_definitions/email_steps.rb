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
# find_email

module EmailHelpers
  def current_email_address
    "quentin@example.com" # Replace with your a way to find your current_email. e.g current_user.email
  end
end
World(EmailHelpers)

# Use this step to reset the e-mail queue within a scenario.
# This is done automatically before each scenario.
Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

# Use this step to open the most recently sent e-mail. 
When /^I open the email$/ do
  open_email(current_email_address)
end

When %r{^I follow "([^"]*?)" in the email$} do |link|
  visit_in_email(link)
end

Then /^I should receive (an|\d+) emails?$/ do |amount|
  amount = 1 if amount == "an"
  unread_emails_for(current_email_address).size.should == amount.to_i
end

Then %r{^"([^"]*?)" should receive (\d+) emails?$} do |address, n|
  unread_emails_for(address).size.should == n.to_i 
end

Then %r{^"([^"]*?)" should have (\d+) emails?$} do |address, n|
  mailbox_for(address).size.should == n.to_i
end

Then %r{^"([^"]*?)" should not receive an email$} do |address|
  find_email(address).should be_nil
end

Then %r{^I should see "([^"]*?)" in the subject$} do |text|
  current_email.should have_subject(Regexp.new(text))
end

Then %r{^I should see "([^"]*?)" in the email$} do |text|
  current_email.body.should =~ Regexp.new(text)
end

When %r{^"([^"]*?)" opens? the email with subject "([^"]*?)"$} do |address, subject|
  open_email(address, :with_subject => subject)
end

When %r{^"([^"]*?)" opens? the email with text "([^"]*?)"$} do |address, text|
  open_email(address, :with_text => text)
end

When /^I click the first link in the email$/ do
  click_first_link_in_email
end

