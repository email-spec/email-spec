require "minitest_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
    @email = UserMailer.signup("jojo@yahoo.com", "Jojo Binks")
  end

  def test_delivered
    assert_must deliver_to("jojo@yahoo.com"), @email
  end

  def test_contains_users_name
    assert_must have_body_text(/Jojo Binks/), @email
  end

  def test_link_to_confirmation_page
    assert_must have_body_text(/#{confirm_account_url(:host => 'example.com')}/), @email
  end

  def test_subject
    assert_must have_subject(/Account confirmation/), @email
  end
end
