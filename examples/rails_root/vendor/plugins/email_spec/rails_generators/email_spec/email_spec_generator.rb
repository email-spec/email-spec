# This generator adds email steps to the step definitions directory 
class EmailSpecGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'features/step_definitions'
      m.file      'email_steps.rb', 'features/step_definitions/email_steps.rb'
    end
  end

protected

  def banner
    "Usage: #{$0} email_spec"
  end

end
