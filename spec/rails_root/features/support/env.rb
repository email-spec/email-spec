# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

require 'webrat/rails'
require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'

require File.expand_path(File.dirname(__FILE__) + '../../../../../lib/email_spec/email_spec_feature_setup.rb')


# /Users/mischa/Projects/Rails/cycle/vendor/plugins/email-spec/lib/email_spec/email_spec_feature_setup.rb 
# /Users/mischa/Projects/Rails/cycle/vendor/plugins/email-spec/spec/lib/email_spec/email_spec_feature_setup.rb 
