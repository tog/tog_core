class CommentsController < ApplicationController

  def create
    commentable = Comment.find_commentable params[:comment][:commentable_type], params[:comment][:commentable_id]

    @comment = commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id if !current_user.nil?
    @comment.approved = !commentable.respond_to?("moderated") || !commentable.moderated || commentable.owner == current_user

    respond_to do |format|
      if @comment.save
        CommentMailer.deliver_new_comment_notification(@comment)
        if @comment.approved
          flash[:ok] = 'Comment added'
        else
          flash[:warning] = "Comments for this entry are moderated, so it won't be shown until a moderator approvesit"
        end
      else
        flash[:error] = 'Error while saving your comment'
      end
      format.html { redirect_to request.referer }
    end
  end

  def remove
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      if comment.destroy
        flash[:ok] = 'Comment removed'
      else
        flash[:error] = 'Error removing comment'
      end
    else
      flash[:error] = 'Error removing comment'
    end

    redirect_to request.referer
  end

  def approve
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      comment.approved = true
      if comment.save
        flash[:ok] = 'Comment approved'
      else
        flash[:error] = 'Error approving comment'
      end
    else
      flash[:error] = 'Error approving comment'
    end

    redirect_to request.referer
  end

end
