require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

class CommentableModel;end;
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < ActionController::TestCase


  context "The comments controller" do
    setup do
      @request.env['HTTP_REFERER'] = "http://www.example.com"

      @owner = Factory(:user, :login => "test")
      @commentable_model_1 = mock
      @commentable_model_1.stubs({:id => 1,
                                  :owner => @owner, 
                                  :new_record? => false,
                                  :comments => Comment, 
                                  :title_for_comment =>"The commentable title",
                                  :class => CommentableModel})
      @commentable_model_1.class.stubs(:base_class).returns(CommentableModel)
      @commentable_model_1.class.stubs(:find).returns(@commentable_model_1)

      Comment.stubs(:find_commentable).returns(@commentable_model_1)
      Comment.any_instance.stubs(:commentable_owner_email).returns(@owner.email)

    end

    [:get, :post].each {|verb|
      should_route verb, "/comments", :controller => :comments, :action => :create
    }
    
    context "when POST-ing a comment" do
      setup do
        Cerberus.stubs(:check_spam).returns(false)
        do_create
      end
      should_create_comment_and_redirect
      should "send an email to the commented item owner" do
        assert_sent_email do |email|
           email.to.include?(@owner.email)
        end
      end
    end
    
    context "when POST-ing a comment that is spam" do
      setup do
        Cerberus.stubs(:check_spam).returns(true)
        do_create
      end
      should_create_comment_and_redirect
      should "mark it as spam" do
        assert Comment.last.spam, "The new comment should be marked as spam."
      end
    end
  end

  def do_create
    post :create, :comment => { :name => 'Ronald', :comment => 'This is the comment', :commentable => @commentable_model_1}
  end
end