# encoding: utf-8
require File.expand_path("../lib/email_spec/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "email_spec"
  s.version = EmailSpec::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Mabey", "Aaron Gibralter", "Mischa Fierer"]
  s.date = "2014-05-27"
  s.description = "Easily test email in RSpec, Cucumber, and MiniTest"
  s.email = "ben@benmabey.com"
  s.license = 'MIT'
  s.extra_rdoc_files = [
    "README.md",
    "MIT-LICENSE.txt"
  ]
  s.files = [
    "README.md",
    "History.txt",
    "MIT-LICENSE.txt",
    "Rakefile",
    "lib/email-spec.rb",
    "lib/email_spec.rb",
    "lib/email_spec/address_converter.rb",
    "lib/email_spec/background_processes.rb",
    "lib/email_spec/cucumber.rb",
    "lib/email_spec/deliveries.rb",
    "lib/email_spec/email_viewer.rb",
    "lib/email_spec/errors.rb",
    "lib/email_spec/helpers.rb",
    "lib/email_spec/mail_ext.rb",
    "lib/email_spec/matchers.rb",
    "lib/email_spec/test_observer.rb",
    "lib/generators/email_spec/steps/USAGE",
    "lib/generators/email_spec/steps/steps_generator.rb",
    "lib/generators/email_spec/steps/templates/email_steps.rb",
    "rails_generators/email_spec/email_spec_generator.rb",
    "rails_generators/email_spec/templates/email_steps.rb"
  ]
  s.homepage = "http://github.com/bmabey/email-spec/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "email-spec"
  s.rubygems_version = "1.8.10"
  s.summary = "Easily test email in rspec and cucumber and minitest"

  s.add_dependency "htmlentities", '~> 4.3.3'
  s.add_dependency "launchy", "~> 2.1"
  s.add_dependency "mail", "~> 2.6.3"

  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "cucumber", '~> 1.3.17'
  s.add_development_dependency "cucumber-rails", '~> 1.4.2'
  s.add_development_dependency "cucumber-sinatra", '~> 0.5.0'
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rspec", '~> 3.1'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'

  s.add_development_dependency "test-unit"
end
