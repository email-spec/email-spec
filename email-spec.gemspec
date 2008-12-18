# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{email-spec}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Mabrey", "Aaron Gibralter", "Mischa Fierer"]
  s.date = %q{2008-12-18}
  s.description = %q{Easily test email in rspec and cucumber}
  s.email = %q{f.mischa@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE.txt"]
  s.files = ["History.txt", "install.rb", "MIT-LICENSE.txt", "README.rdoc", "Rakefile", "lib/email_spec", "lib/email_spec/email_spec_feature_setup.rb", "lib/email_spec/email_spec_helpers.rb", "lib/email_spec/email_spec_matchers.rb", "lib/email_spec/email_spec_steps.rb", "lib/email_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bmabey/email-spec/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easily test email in rspec and cucumber}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
