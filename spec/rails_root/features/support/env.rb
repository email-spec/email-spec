# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

require 'webrat/rails'
require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'

require File.expand_path(File.dirname(__FILE__) + '../../../../../lib/email_spec/cucumber.rb')

def current_email_address
  "quentin@example.com"
end

