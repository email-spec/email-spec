# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

require 'webrat/rails'
#require 'email_spec_feature_setup'

require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'
