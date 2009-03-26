require 'rubygems'
require 'spec/rake/spectask'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name         = "email_spec"
    s.platform     = Gem::Platform::RUBY
    s.authors      = ['Ben Mabey', 'Aaron Gibralter', 'Mischa Fierer']
    s.email        = "ben@benmabey.com"
    s.homepage     = "http://github.com/bmabey/email-spec/"
    s.summary      = "Easily test email in rspec and cucumber"
    s.bindir       = "bin"
    s.description  = s.summary
    s.require_path = "lib"
    s.files        = %w(History.txt install.rb MIT-LICENSE.txt README.rdoc Rakefile) + Dir["lib/**/*"] + Dir["generators/**/*"] + Dir["spec/**/*"] + Dir["examples/**/*"]
    # rdoc
    s.has_rdoc         = true
    s.extra_rdoc_files = %w(README.rdoc MIT-LICENSE.txt)
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# Testing

desc "Run the generator on the tests"
task :generate do
  current_dir = File.expand_path(File.dirname(__FILE__))
  system "mkdir -p #{current_dir}/examples/rails_root/vendor/plugins/email_spec"
  system "cp -R #{current_dir}/rails_generators #{current_dir}/examples/rails_root/vendor/plugins/email_spec"
  system "cd #{current_dir}/examples/rails_root && ./script/generate email_spec"
end

task :migrate do
	system("cd examples/rails_root/ && rake db:test:prepare")
end

task :features => :generate do
  system("cucumber examples/rails_root/")
  puts "4 steps should fail.\n\n"
end

task :specs do
  system("spec examples/rails_root -c --format nested")
  system("spec spec -c --format nested")
end

task :default => [:migrate, :features, :specs]

