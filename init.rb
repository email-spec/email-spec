if RAILS_ENV == "test"
  %w[helpers matchers].each do |file|
    require File.join(File.dirname(__FILE__), "lib/email_spec_#{file}.rb")
  end
end