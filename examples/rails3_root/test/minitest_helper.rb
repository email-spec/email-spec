ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/matchers"
require "minitest/rails"

# Uncomment if you want Capybara in accceptance/integration tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

require "email_spec"

class ActionMailer::TestCase
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ::Rails.application.routes.url_helpers
end

# Do you want all existing Rails tests to use MiniTest::Rails?
# Comment out the following and either:
# A) Change the require on the existing tests to `require "minitest_helper"`
# B) Require this file's code in test_helper.rb

# MiniTest::Rails.override_testunit!
