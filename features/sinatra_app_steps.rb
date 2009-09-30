Given /the example sinatra app$/ do
end

When /^I run "([^\"]*)" in the sinatra root$/ do |cmd|
  cmd.gsub!('cucumber', "#{Cucumber::RUBY_BINARY} #{Cucumber::BINARY}")
  root_dir = File.join(File.expand_path(File.dirname(__FILE__)), "..")
  Dir.chdir(File.join(root_dir, 'examples', 'sinatra')) do
    @output = `#{cmd}`
  end
end
