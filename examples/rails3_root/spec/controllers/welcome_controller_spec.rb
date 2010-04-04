require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do

  describe "POST /signup (#signup)" do
    it "should deliver the signup email" do
      # expect
      # UserMailer.should_receive(:signup).with("email@example.com", "Jimmy Bean")
      # when
      
      lambda {
        post :signup, "Email" => "email@example.com", "Name" => "Jimmy Bean"
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
      
      last_delivery = ActionMailer::Base.deliveries.last      
      last_delivery.to.should include "email@example.com"
      last_delivery.body.to_s.should include "Jimmy Bean"
    end

  end

end
