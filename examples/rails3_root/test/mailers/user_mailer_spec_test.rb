require "minitest_helper"

# Uncomment this line when RSpec no longer loads the DSL in every project that
# has a dependency on it in the Gemfile, and stomps on MiniTest's `describe`...
# This is not an issue for Rails projects that don't use RSpec.
#describe UserMailer, :signup do
class UserMailerSpecTest < MiniTest::Rails::ActionMailer::TestCase
  let(:email) { UserMailer.signup("jojo@yahoo.com", "Jojo Binks") }

  it "is delivered to the email passed in" do
    email.must deliver_to("jojo@yahoo.com")
  end

  it "contains the user's name in the mail body" do
    email.must have_body_text(/Jojo Binks/)
  end

  it "contains a link to the confirmation page" do
    email.must have_body_text(/#{confirm_account_url(:host => 'example.com')}/)
  end

  it "contains the correct subject" do
    email.must have_subject(/Account confirmation/)
  end

  describe "more concise specs using 'it'" do
    subject { UserMailer.signup("jojo@yahoo.com", "Jojo Binks") }

    it { must have_body_text(/#{confirm_account_url(:host => 'example.com')}/) }
    it { must have_subject(/Account confirmation/) }

    describe "sent with email address of 'jojo@yahoo.com', and users name 'Jojo Binks'" do
      it { must deliver_to("jojo@yahoo.com") }
      it { must have_body_text(/Jojo Binks/) }
    end
  end

  describe "more concise specs using 'must'" do
    subject { UserMailer.signup("jojo@yahoo.com", "Jojo Binks") }

    must { have_body_text(/#{confirm_account_url(:host => 'example.com')}/) }
    must { have_subject(/Account confirmation/) }

    describe "sent with email address of 'jojo@yahoo.com', and users name 'Jojo Binks'" do
      must { deliver_to("jojo@yahoo.com") }
      must { have_body_text(/Jojo Binks/) }
    end
  end
end
