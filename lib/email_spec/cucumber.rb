# require this in your env.rb file after you require cucumber/rails/world

%w[helpers matchers].each do |file|
  require File.join(File.dirname(__FILE__), "email_spec_#{file}.rb")
end

# Global Setup
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true

Before do 
  # Scenario setup
  ActionMailer::Base.deliveries.clear
end

World do |world|
  world.extend EmailSpec::Helpers
  world.extend EmailSpec::Matchers
end
