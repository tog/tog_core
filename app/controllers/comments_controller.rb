class CommentsController < ApplicationController

  def create
    commentable = Comment.find_commentable params[:comment][:commentable_type], params[:comment][:commentable_id]

    @comment = commentable.comments.new(params[:comment])
    @comment.user = current_user
    @comment.approved = !commentable.respond_to?("moderated") || !commentable.moderated || commentable.owner == current_user

    respond_to do |format|
      if @comment.save
        CommentMailer.deliver_new_comment_notification(@comment)
        if @comment.approved
          flash[:comment_notice] = 'Comment added'
        else
          flash[:comment_notice] = "Comments for this entry are moderated, so it won't be shown until a moderator approvesit"
        end
      else
        flash[:comment_notice] = 'Error while saving your comment'
      end
      format.html { redirect_to request.referer }
    end
  end

  def remove
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      if comment.destroy
        flash[:comment_notice] = 'Comment removed'
      else
        flash[:comment_notice] = 'Error removing comment'
      end
    else
      flash[:comment_notice] = 'Error removing comment'
    end

    redirect_to request.referer
  end

  def approve
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      comment.approved = true
      if comment.save
        flash[:comment_notice] = 'Comment approved'
      else
        flash[:comment_notice] = 'Error approving comment'
      end
    else
      flash[:comment_notice] = 'Error approving comment'
    end

    redirect_to request.referer
  end

end
