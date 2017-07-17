# Require this in your spinach features/support/env.rb file to get access
# to the helpers and matchers in your steps.

if defined?(ActionMailer)
  unless [:test, :activerecord, :cache, :file].include?(ActionMailer::Base.delivery_method)
    ActionMailer::Base.register_observer(EmailSpec::TestObserver)
  end
  ActionMailer::Base.perform_deliveries = true

  Spinach.hooks.before_scenario do
    # Scenario setup
    case ActionMailer::Base.delivery_method
      when :test then ActionMailer::Base.deliveries.clear
      when :cache then ActionMailer::Base.clear_cache
    end
  end
end

Spinach.hooks.after_scenario do
  EmailSpec::EmailViewer.save_and_open_all_raw_emails if ENV['SHOW_EMAILS']
  EmailSpec::EmailViewer.save_and_open_all_html_emails if ENV['SHOW_HTML_EMAILS']
  EmailSpec::EmailViewer.save_and_open_all_text_emails if ENV['SHOW_TEXT_EMAILS']
end

class Spinach::FeatureSteps
  include EmailSpec::Helpers
  include EmailSpec::Matchers
end
