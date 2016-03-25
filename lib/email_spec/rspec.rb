RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.before(:each) do |group|
    reset_mailer
  end
end
