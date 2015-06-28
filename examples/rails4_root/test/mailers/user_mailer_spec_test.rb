require "test_helper"

# Uncomment this line when RSpec no longer loads the DSL in every project that
# has a dependency on it in the Gemfile, and stomps on MiniTest's `describe`...
# This is not an issue for Rails projects that don't use RSpec.
#describe UserMailer, :signup do
class UserMailerSpec < Minitest::Spec
  include ::Rails.application.routes.url_helpers
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:email) { UserMailer.signup("jojo@yahoo.com", "Jojo Binks") }

  def test_is_delivered_to_the_email_passed_in
    email.must deliver_to("jojo@yahoo.com")
  end

  def test_contains_the_users_name_in_the_mail_body
    email.must have_body_text(/Jojo Binks/)
  end

  def test_contains_a_link_to_the_confirmation_page
    email.must have_body_text(/#{confirm_account_url(:host => 'example.com')}/)
  end

  def test_contains_the_correct_subject
    email.must have_subject(/Account confirmation/)
  end
end
