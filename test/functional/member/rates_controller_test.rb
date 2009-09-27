require File.dirname(__FILE__) + '/../../test_helper'
require 'acts_as_rateable'

class RateableModel;end;

class Member::RatesControllerTest < ActionController::TestCase


  context "Given an object" do
    setup do
      @request.env['HTTP_REFERER'] = "http://www.example.com"
      
      @owner = Factory(:user, :login => "test")
      @rateable_model_1 = mock
      @rateable_model_1.stubs({:id => 1,
                               :class => RateableModel})
      @rateable_model_1.class.stubs(:base_class).returns(RateableModel)
      @rateable_model_1.class.stubs(:find).returns(@rateable_model_1)
      @rateable_model_1.stubs(:rate_it).with(any_parameters).returns(nil)
      @rateable_model_1.stubs(:rated_by?).with(any_parameters).returns(false)
      
      @request.session[:user_id]= @owner.id      

    end
    
    [:get, :post].each {|verb|
      should_route verb, "/member/rate", :controller => "member/rates", :action => :create
    }    
    
    context "when POST-ing a rate" do
      setup do
        post :create, :type => @rateable_model_1.class.name, :id => @rateable_model_1.id, :rate => 2
      end
      
      should_respond_with :redirect
      should_redirect_to ("http://www.example.com") { "http://www.example.com" }
#      should_change "Comment.count", :by => 1
    end
  end      
end
