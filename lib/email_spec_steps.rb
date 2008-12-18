Given "a clear email queue" do
  reset_mailer
end

# user perspective
When %r{^'([^']*?)' opens the email with subject '([^']*?)'$} do |email, subject|
  open_email(email, :with_subject => subject).should_not be_nil
end

When %r{^'([^']*?)' opens the email with text '([^']*?)'$} do |email, text|
  open_email(email, :with_text => text).should_not be_nil
end

When %r{^.*?follows? "([^']*?)" in the email$} do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  get(link)
end

When %r{^.*?clicks? "([^']*?)" in the email$} do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  get_via_redirect(link)
end

Then %r{^'([^']*?)' should have (\d+) new emails?$} do |email, n|
  unread_emails_for(email).size.should == n.to_i
end

Then %r{^'([^']*?)' should have (\d+) emails?$} do |email, n|
  mailbox_for(email).size.should == n.to_i
end

# system perspective
Then %r{^an email should be sent to "([^']*?)"$} do |email|
  open_email(email).should_not be_nil
end
  
Then %r{^an email should not be sent to "([^']*?)"$} do |email|
  open_email(email).should be_nil
end

Then %r{^.*? should see "([^']*?)" in the email subject$} do |text|
  current_email.should_not be_nil
  current_email.subject.should =~ Regexp.new(text)
end

Then %r{^.*? should see "([^']*?)" in the email$} do |text|
  current_email.should_not be_nil
  current_email.body.should =~ Regexp.new(text)
end
