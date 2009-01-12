class CommentsController < ApplicationController

  def create
    commentable = Comment.find_commentable params[:comment][:commentable_type], params[:comment][:commentable_id]

    @comment = commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id if !current_user.nil?
    @comment.approved = !commentable.respond_to?("moderated") || !commentable.moderated || commentable.owner == current_user

    @comment.spam = Cerberus.check_spam(@comment, request)

    respond_to do |format|
      if @comment.save
        deliver_new_comment_notification(@comment, request.referer)
        if @comment.approved
          flash[:ok] = I18n.t("tog_core.site.comment.added")
        else
          flash[:warning] = I18n.t("tog_core.site.comment.left_pending")
        end
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_commenting")
      end
      format.html { redirect_to request.referer }
    end
  end

  def remove
    comment = Comment.find params[:id]

    if admin? || comment.commentable_owner == current_user
      if comment.destroy
        flash[:ok] = I18n.t("tog_core.site.comment.removed")
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_removing")
      end
    else
      flash[:error] = I18n.t("tog_core.site.comment.error_removing")
    end

    redirect_to request.referer
  end

  def approve
    comment = Comment.find params[:id]

    if admin? || comment.commentable_owner == current_user
      comment.approved = true
      if comment.save
        flash[:ok] = I18n.t("tog_core.site.comment.approved")
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_approving")
      end
    else
      flash[:error] = I18n.t("tog_core.site.comment.error_approving")
    end

    redirect_to request.referer
  end

  private
  
  def deliver_new_comment_notification(comment, referer)
    if comment.commentable_owner_email && !comment.spam
      CommentMailer.deliver_new_comment_notification(comment, referer)
    end
  end
end
