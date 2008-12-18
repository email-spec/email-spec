# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{email_spec}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Mabrey", "Aaron Gibralter", "Mischa Fierer"]
  s.date = %q{2008-12-18}
  s.description = %q{Easily test email in rspec and cucumber}
  s.email = %q{f.mischa@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE.txt"]
  s.files = ["History.txt", "install.rb", "MIT-LICENSE.txt", "README.rdoc", "Rakefile", "lib/email_spec", "lib/email_spec/cucumber.rb", "lib/email_spec/email_spec_helpers.rb", "lib/email_spec/email_spec_matchers.rb", "lib/email_spec.rb", "generators/email_spec", "generators/email_spec/email_spec_generator.rb", "generators/email_spec/templates", "generators/email_spec/templates/email_steps.rb", "spec/email_spec_helpers_spec.rb", "spec/rails_root", "spec/rails_root/app", "spec/rails_root/app/controllers", "spec/rails_root/app/controllers/application.rb", "spec/rails_root/app/controllers/welcome_controller.rb", "spec/rails_root/app/helpers", "spec/rails_root/app/helpers/application_helper.rb", "spec/rails_root/app/helpers/welcome_helper.rb", "spec/rails_root/app/models", "spec/rails_root/app/models/user_mailer.rb", "spec/rails_root/app/views", "spec/rails_root/app/views/user_mailer", "spec/rails_root/app/views/user_mailer/signup.erb", "spec/rails_root/app/views/welcome", "spec/rails_root/app/views/welcome/confirm.html.erb", "spec/rails_root/app/views/welcome/index.html.erb", "spec/rails_root/app/views/welcome/signup.html.erb", "spec/rails_root/config", "spec/rails_root/config/boot.rb", "spec/rails_root/config/database.yml", "spec/rails_root/config/environment.rb", "spec/rails_root/config/environments", "spec/rails_root/config/environments/development.rb", "spec/rails_root/config/environments/production.rb", "spec/rails_root/config/environments/test.rb", "spec/rails_root/config/initializers", "spec/rails_root/config/initializers/inflections.rb", "spec/rails_root/config/initializers/mime_types.rb", "spec/rails_root/config/initializers/new_rails_defaults.rb", "spec/rails_root/config/routes.rb", "spec/rails_root/db", "spec/rails_root/db/development.sqlite3", "spec/rails_root/db/schema.rb", "spec/rails_root/db/test.sqlite3", "spec/rails_root/doc", "spec/rails_root/doc/README_FOR_APP", "spec/rails_root/features", "spec/rails_root/features/errors.feature", "spec/rails_root/features/example.feature", "spec/rails_root/features/step_definitions", "spec/rails_root/features/step_definitions/email_steps.rb", "spec/rails_root/features/step_definitions/webrat_steps.rb", "spec/rails_root/features/support", "spec/rails_root/features/support/env.rb", "spec/rails_root/lib", "spec/rails_root/lib/tasks", "spec/rails_root/lib/tasks/cucumber.rake", "spec/rails_root/lib/tasks/rspec.rake", "spec/rails_root/log", "spec/rails_root/log/development.log", "spec/rails_root/log/test.log", "spec/rails_root/public", "spec/rails_root/public/404.html", "spec/rails_root/public/422.html", "spec/rails_root/public/500.html", "spec/rails_root/public/dispatch.rb", "spec/rails_root/public/favicon.ico", "spec/rails_root/public/images", "spec/rails_root/public/images/rails.png", "spec/rails_root/public/javascripts", "spec/rails_root/public/javascripts/application.js", "spec/rails_root/public/javascripts/controls.js", "spec/rails_root/public/javascripts/dragdrop.js", "spec/rails_root/public/javascripts/effects.js", "spec/rails_root/public/javascripts/prototype.js", "spec/rails_root/public/robots.txt", "spec/rails_root/public/stylesheets", "spec/rails_root/Rakefile", "spec/rails_root/script", "spec/rails_root/script/about", "spec/rails_root/script/autospec", "spec/rails_root/script/console", "spec/rails_root/script/cucumber", "spec/rails_root/script/dbconsole", "spec/rails_root/script/destroy", "spec/rails_root/script/generate", "spec/rails_root/script/performance", "spec/rails_root/script/performance/benchmarker", "spec/rails_root/script/performance/profiler", "spec/rails_root/script/performance/request", "spec/rails_root/script/plugin", "spec/rails_root/script/process", "spec/rails_root/script/process/inspector", "spec/rails_root/script/process/reaper", "spec/rails_root/script/process/spawner", "spec/rails_root/script/runner", "spec/rails_root/script/server", "spec/rails_root/script/spec", "spec/rails_root/script/spec_server", "spec/rails_root/spec", "spec/rails_root/spec/rcov.opts", "spec/rails_root/spec/spec.opts", "spec/rails_root/spec/spec_helper.rb", "spec/rails_root/tmp", "spec/rails_root/tmp/cache", "spec/rails_root/tmp/pids", "spec/rails_root/tmp/sessions", "spec/rails_root/tmp/sockets", "spec/rails_root/vendor", "spec/rails_root/vendor/plugins", "spec/rails_root/vendor/plugins/email_spec", "spec/rails_root/vendor/plugins/email_spec/generators", "spec/rails_root/vendor/plugins/email_spec/generators/email_spec", "spec/rails_root/vendor/plugins/email_spec/generators/email_spec/email_spec_generator.rb", "spec/rails_root/vendor/plugins/email_spec/generators/email_spec/templates", "spec/rails_root/vendor/plugins/email_spec/generators/email_spec/templates/email_steps.rb"]
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
