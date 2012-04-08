require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/email_spec/steps/steps_generator'

describe EmailSpec::StepsGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination(File.expand_path("../../../../../tmp", __FILE__))

  before { prepare_destination }

  describe 'no arguments' do
    before { run_generator  }

    describe 'features/step_definitions/email_steps.rb' do
      subject { file('features/step_definitions/email_steps.rb') }
      it { should exist }
      it { should contain "# Commonly used email steps" }
    end
  end
end
