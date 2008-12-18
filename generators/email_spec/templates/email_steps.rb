#Commonly used email steps

# Use this step to reset the e-mail queue within a scenario.
# This is done automatically before each scenario.
Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

# Use this step to open the most recently sent e-mail. 
When /^I open the email$/ do
  open_last_email
end

When /^I follow "(.*)" in the email$/ do |link|
  visit_in_email(link)
end

Then /^I should receive (\d+) emails?$/ do |n|
  unread_emails_for(current_email_address).size.should == n.to_i
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
#  raise ArgumentError, "To check the subject, you must first open an e-mail" if current_email.nil?
#  current_email.should_not be_nil
  current_email.subject.should =~ Regexp.new(text)
end

Then /^I should see "(.*)" in the email$/ do |text|
#  current_email.should_not be_nil
  current_email.body.should =~ Regexp.new(text)
end

When %r{^'([^']*?)' opens? the email with subject "([^']*?)"$} do |email, subject|
  open_email(email, :with_subject => subject).should_not be_nil
end

When %r{^'([^']*?)' opens? the email with text "([^']*?)"$} do |email, text|
  open_email(email, :with_text => text).should_not be_nil
end


