require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController, :type => :controller do

  describe "POST /signup (#signup)" do
    it "should deliver the signup email" do
      expect {
        post :signup, "Email" => "email@example.com", "Name" => "Jimmy Bean"
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      last_delivery = ActionMailer::Base.deliveries.last
      expect(last_delivery.to).to include "email@example.com"
      #message is now multipart, make sure both parts include Jimmy Bean
      expect(last_delivery.parts[0].body.to_s).to include "Jimmy Bean"
      expect(last_delivery.parts[1].body.to_s).to include "Jimmy Bean"
    end

  end

end
