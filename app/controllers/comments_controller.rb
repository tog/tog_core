class CommentsController < ApplicationController

  def create
    commentable = Comment.find_commentable params[:comment][:commentable_type], params[:comment][:commentable_id]

    @comment = commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id if !current_user.nil?
    @comment.approved = !commentable.respond_to?("moderated") || !commentable.moderated || commentable.owner == current_user

    @comment.spam = check_spam(@comment)

    respond_to do |format|
      if @comment.save
        CommentMailer.deliver_new_comment_notification(@comment, request.referer)
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

  private
  def check_spam(comment)
    if !Tog::Plugins.settings(:tog_core, 'spam.engine').blank? && !Tog::Plugins.settings(:tog_core, 'spam.key').blank?
      viking = Viking.connect(Tog::Plugins.settings(:tog_core, 'spam.engine'),
                              :api_key => Tog::Plugins.settings(:tog_core, 'spam.key'),
                              :blog    => Tog::Plugins.settings(:tog_core, 'spam.url'))
      
      return false unless viking.verified?
      
      result = viking.check_comment(
        :user_ip => request.remote_ip,
        :article_date => comment.commentable.created_at,
        :comment_type => 'comment',
        :comment_author => comment.author_name,
        :comment_author_email => comment.author_email,
        :comment_content => comment.comment,
        :user_agent => request.env['HTTP_USER_AGENT'],
        :referrer   => request.env['HTTP_REFERER']
      )
      result[:spam]
    else
      false
    end
  end

end
