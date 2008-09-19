module CommentsHelper
  def comment_user_name(comment)
    if comment.by_user?
      comment.user.login
    elsif comment.by_visitor? && !comment.name.blank?
      comment.name
    else 
      "Anonymous"
    end
  end
end
