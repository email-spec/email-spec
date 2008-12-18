require 'rubygems'
require "rake/gempackagetask"
require 'rake/rdoctask'
require "rake/clean"
require 'spec'
require 'spec/rake/spectask'
require File.expand_path('./lib/email_spec.rb')

##############################################################################
# Package && release
##############################################################################
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

  # Dependencies
 # s.add_dependency "nokogiri", ">= 1.0.6"
  
 # s.rubyforge_project = "webrat"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Show information about the gem.'
task :debug_gem do
  puts spec.to_ruby
end

CLEAN.include ["pkg", "*.gem", "doc", "ri", "coverage", '**/.*.sw?', '*.gem', '.config', '**/.DS_Store', '**/*.class', '**/*.jar', '**/.*.swp' ]

desc "Run API and Core specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run all specs in spec directory with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = lambda do
    IO.readlines(File.dirname(__FILE__) + "/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
  end
end

desc 'Install the package as a gem.'
task :install_gem => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --local #{gem}"
end

task :gemspec do
  system "rake debug_gem | grep -v \"(in \" > email-spec.gemspec"
end

desc "Delete generated RDoc"
task :clobber_docs do
  FileUtils.rm_rf("doc")
end

desc "Generate RDoc"
task :docs => :clobber_docs do
  system "hanna --title 'Webrat #{Webrat::VERSION} API Documentation'"
end


task :test_features do
  puts "hi"
end

task :default => :test_features

