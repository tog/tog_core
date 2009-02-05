require File.dirname(__FILE__) + '/../../test_helper'
require 'comments_controller'

class CommentableModel;end;
class CommentsController; def rescue_action(e) raise e end; end

class Member::CommentsControllerTest < ActionController::TestCase


  context "Given a comment" do
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

      @request.session[:user_id]= @owner.id      

      @comment = Factory(:comment, :commentable_type => @commentable_model_1.class.name, :commentable_id => @commentable_model_1.id)
    end
    
    [:get, :post].each {|verb|
      should_route verb, "/member/comments/1/approve", :controller => "member/comments", :action => :approve, :id => 1
      should_route verb, "/member/comments/1/remove",  :controller => "member/comments", :action => :remove,  :id => 1
    }
    
    context "on POST to :approve" do
      setup do
        post :approve, :id => @comment.id
      end
      should "be approved" do
        comment = Comment.find @comment.id
        assert comment.approved
      end
      
      should_set_the_flash_to I18n.t("tog_core.site.comment.approved")
      should_respond_with :redirect
      should_redirect_to '"http://www.example.com"'
    end
    
    context "on POST to :remove" do
      setup do
        post :remove, :id => @comment.id
      end
      
      should_change "Comment.count", :by => -1
      should_set_the_flash_to I18n.t("tog_core.site.comment.removed")
      should_respond_with :redirect
      should_redirect_to '"http://www.example.com"'
    end
  end

end