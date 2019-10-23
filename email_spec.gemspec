# encoding: utf-8
require File.expand_path("../lib/email_spec/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "email_spec"
  s.version = EmailSpec::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Mabey", "Aaron Gibralter", "Mischa Fierer"]
  s.description = "Easily test email in RSpec, Cucumber, and MiniTest"
  s.email = "ben@benmabey.com"
  s.license = 'MIT'
  s.extra_rdoc_files = [
    "README.md",
    "MIT-LICENSE.txt"
  ]
  s.files = [
    "README.md",
    "Changelog.md",
    "MIT-LICENSE.txt",
    "Rakefile"
  ]
  s.files += Dir['examples/**/*'] + Dir['features/**/*'] + Dir['lib/**/*.rb'] +
             Dir['spec/**/*']
  s.homepage = "http://github.com/email-spec/email-spec/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Easily test email in RSpec, Cucumber or Minitest"

  s.add_dependency "htmlentities", '~> 4.3.3'
  s.add_dependency "launchy", "~> 2.1"
  s.add_dependency "mail", "~> 2.7"

  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "cucumber", '~> 1.3.17'
  s.add_development_dependency "actionmailer", "~> 4.2"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rspec", '~> 3.1'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'

  s.add_development_dependency "test-unit"
end
