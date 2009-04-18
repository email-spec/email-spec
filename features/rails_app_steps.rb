require 'fileutils'

Given /^the example rails app is setup with the latest generators$/ do
  root_dir = File.join(File.expand_path(File.dirname(__FILE__)), "..")

  FileUtils.rm("#{root_dir}/examples/rails_root/features/step_definitions/email_steps.rb")
  FileUtils.mkdir_p("#{root_dir}/examples/rails_root/vendor/plugins/email_spec")
  FileUtils.cp_r("#{root_dir}/rails_generators", "#{root_dir}/examples/rails_root/vendor/plugins/email_spec/")

  Dir.chdir(File.join(root_dir, 'examples', 'rails_root')) do
    system "./script/generate email_spec"
  end

end

When /^I run "([^\"]*)"$/ do |cmd|
  root_dir = File.join(File.expand_path(File.dirname(__FILE__)), "..")
  Dir.chdir(File.join(root_dir, 'examples', 'rails_root')) do
    @output = `#{cmd}`
  end
end

Then /^I should see the following summary report:$/ do |expected_report|
  @output.should include(expected_report)
end

