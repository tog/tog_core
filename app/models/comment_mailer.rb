class CommentMailer < ActionMailer::Base

  def new_comment_notification(comment)
    setup_email(comment)
    @subject    += "New comment "
    @subject    += " pending " unless comment.approved
    @subject    += " in #{comment.commentable.title_for_comment} "
  end

  protected
    def setup_email(comment)
      @recipients  = "#{comment.commentable.owner.email}"
      @from        = Tog::Config["plugins.tog_core.mail.system_from_address"]
      @subject     = Tog::Config["plugins.tog_core.mail.default_subject"]
      @sent_on     = Time.now
      @content_type = "text/html"
      @body[:comment] = comment
    end
end
