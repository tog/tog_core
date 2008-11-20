class Test::Unit::TestCase
  
  def self.should_create_comment_and_redirect
    should_respond_with :redirect
    should_redirect_to '"http://www.test.com"'
    should_change "Comment.count", :by => 1
  end
  
end