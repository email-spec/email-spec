require 'rubygems'
require "rake/gempackagetask"
require 'rake/rdoctask'
require "rake/clean"
require 'spec'
require 'spec/rake/spectask'
require File.expand_path('./lib/email_spec.rb')

# Package && release
spec = Gem::Specification.new do |s|
  s.name         = "email-spec"
  s.version      = EmailSpec::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Ben Mabrey', 'Aaron Gibralter', 'Mischa Fierer']
  s.email        = "f.mischa@gmail.com"
  s.homepage     = "http://github.com/bmabey/email-spec/"
  s.summary      = "Easily test email in rspec and cucumber"
  s.bindir       = "bin"
  s.description  = s.summary
  s.require_path = "lib"
  s.files        = %w(History.txt install.rb MIT-LICENSE.txt README.rdoc Rakefile) + Dir["lib/**/*"]
  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc MIT-LICENSE.txt)
end

desc 'Show information about the gem.'
task :debug_gem do
  puts spec.to_ruby
end

CLEAN.include ["pkg", "*.gem", "doc", "ri", "coverage", '**/.*.sw?', '*.gem', '.config', '**/.DS_Store', '**/*.class', '**/*.jar', '**/.*.swp' ]

desc 'Install the package as a gem.'
task :install_gem => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --local #{gem}"
end

task :gemspec do
  system "rake debug_gem | grep -v \"(in \" > email-spec.gemspec"
end

task :features do
  system("cd spec/rails_root; rake features; cd ../..")
end

task :default => :features

