Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

# Action
#
When /^I open the email$/ do
  open_last_email.should_not be_nil
end

When /^I follow "(.*)" in the email$/ do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  visit(link)
end

When /^I click "(.*)" in the email$/ do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  visit(link)
end


# Verification
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
  raise ArgumentError, "To check the subject, you must first open an e-mail" if current_email.nil?
  current_email.should_not be_nil
  current_email.subject.should =~ Regexp.new(text)
end

Then /^I should see "(.*)" in the email$/ do |text|
  current_email.should_not be_nil
  current_email.body.should =~ Regexp.new(text)
end
