require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

class CommentableModel;end;
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @commentable_model_1 = CommentableModel.new
    @request.env['HTTP_REFERER'] = "http://www.test.com"
    Comment.stubs(:find_commentable).returns(@commentable_model_1)
    Comment.any_instance.stubs(:commentable_owner_email).returns("test@test.com")

    CommentableModel.stubs(:find).returns(@commentable_model_1)
    CommentableModel.any_instance.stubs(:comments).returns(Comment)
    CommentableModel.any_instance.stubs(:title_for_comment).returns("The commentable title")
  end

  context "The comments controller" do

    [:get, :post].each {|verb|
      should_route verb, "/comments/1/approve", :controller => :comments, :action => :approve, :id => 1 
      should_route verb, "/comments/1/remove", :controller => :comments, :action => :remove, :id => 1 
      should_route verb, "/comments", :controller => :comments, :action => :create
    }

    context "given a spam comment" do
      setup do
        Cerberus.stubs(:check_spam).returns(true)
      end
      context "when POST-ing it" do
        setup do
          post :create, :comment => { :name => 'Ronald', :comment => 'This is the comment', :commentable_type => "CommentableModel", :commentable_id => 1 }
        end
        should_respond_with :redirect
        should_redirect_to '"http://www.test.com"'
        should_change "Comment.count", :by => 1
        should "create a new comment marked as spam" do
          assert Comment.last.spam, "The new comment should be marked as spam."
        end

      end
    end

    context "given a ham comment" do
      setup do
        Cerberus.stubs(:check_spam).returns(false)
      end

    end
    context "given any commment" do
      setup do
        @comment = Factory(:comment)
      end
      context "when removing it" do
        setup do
          get :remove, :id => @comment 
        end
        should_change "Comment.count", :by => -1
        
      end
      context "when approving it" do
        setup do
        end
      end
    end
  end
end