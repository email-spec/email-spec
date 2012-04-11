require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :default => [:features, :spec]
