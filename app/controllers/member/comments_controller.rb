class Member::CommentsController < Member::BaseController

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

end
