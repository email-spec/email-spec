Given "a clear email queue" do
  reset_mailer
end

# user perspective
When %r{^'([^']*?)' opens (?:his)|(?:her) email with subject '([^']*?)'$} do |email, subject|
  open_email(email, :with_subject => subject).should_not be_nil
end

When %r{^'([^']*?)' opens (?:his)|(?:her) email containing text '([^']*?)'$} do |email, text|
  open_email(email, :with_text => text).should_not be_nil
end

When %r{^.*?follows '([^']*?)' in (?:his)|(?:her) email$} do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  get(link)
end

When %r{^.*?clicks on '([^']*?)' in (?:his)|(?:her) email$} do |link_text|
  current_email.should_not be_nil
  link = parse_email_for_link(current_email, link_text)
  get_via_redirect(link)
end

Then %r{^'([^']*?)' should have (\d+) new emails?$} do |email, n|
  unread_emails_for(email).size.should == n.to_i
end

Then %r{^'([^']*?)' should have (\d+) total emails?$} do |email, n|
  mailbox_for(email).size.should == n.to_i
end

# system perspective
Then %r{^an email should have been sent to '([^']*?)'$} do |email|
  open_email(email).should_not be_nil
end
  
Then %r{^an email should not have been sent to '([^']*?)'$} do |email|
  open_email(email).should be_nil
end

Then %r{^.*?email should have subject with text '([^']*?)'$} do |text|
  current_email.should_not be_nil
  current_email.subject.should =~ Regexp.new(text)
end

Then %r{^.*?email should include text '([^']*?)'$} do |text|
  current_email.should_not be_nil
  current_email.body.should =~ Regexp.new(text)
end
