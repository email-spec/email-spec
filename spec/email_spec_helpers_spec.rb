# require File.dirname(__FILE__) + '/spec_helper'
# 
# module ActionMailer
#   class Base
#   end  
# end
# 
# 
# module EmailSpec
#   describe Helpers do
#     before(:all) do
#       @helper = Object.new
#       @helper.extend EmailSpec::Helpers
#     end
#     
#     describe "#reset_mailer" do
#       it "should empty the all email deliveries" do
#         #given
#         ActionMailer::Base.stub!(:deliveries).and_return([mock("some email", mock("another email"))])
#         #when
#         @helper.reset_mailer
#         #then
#         ActionMailer::Base.deliveries.should be_empty      
#       end
#     end
#   end
# end
# 
