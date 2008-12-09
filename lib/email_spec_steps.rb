
Given "no emails have been sent" do
  reset_mailer
end
  
Then /^(\w+) should have received (\d+) emails*$/ do |actor, amount|
  email = actor =~ /@/ ? actor : instance_variable_get(actor).email
  emails_sent_to(email).size.should == amount.to_i
end
  
Then /^(\w+) should receive an email$/ do |actor|
  last_email_sent.to.should include(instance_variable_get(actor).email)
end
  
Then /^(\w+) should not receive an email$/ do |actor|
  #This is fragile because it depends on no previous steps sending a email to
  # the said actor before this step.. A Given clause could be used to clean up the mailer but 
  # it would not look good in the stories.. 
  last_email_sent.to.should_not include(instance_variable_get(actor).email)
end

Then /^an email should have been sent to (.+)$/ do |actor_or_email|
  email = actor_or_email["@"] ? actor_or_email : instance_variable_get(actor_or_email).email
  sent_email = ActionMailer::Base.deliveries.find{ |mail| mail.to.include? email }
  sent_email.should_not be_nil
  @current_email = sent_email
end
  
Then /^an email should not have been sent to (.+)/ do |actor_or_email|
  email = actor_or_email["@"] ? actor_or_email : instance_variable_get(actor_or_email).email
  sent_email = ActionMailer::Base.deliveries.find{ |mail| mail.to.include? email }
  sent_email.should be_nil
end
  
Then /^email should include text: "(.*)"$/ do |text|
  @current_email.body.should have_text(/#{text}/)
end