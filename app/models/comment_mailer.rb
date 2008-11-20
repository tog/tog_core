class CommentMailer < ActionMailer::Base

  def new_comment_notification(comment, url=nil)
    
    setup_email(comment, url)
    @subject    += "New comment"
    @subject    += " pending " unless comment.approved
    @subject    += " in #{comment.commentable_title} "
  end

  protected
    def setup_email(comment, url)
      @recipients   = "#{comment.commentable_owner_email}"
      @from         = Tog::Config["plugins.tog_core.mail.system_from_address"]
      @subject      = Tog::Config["plugins.tog_core.mail.default_subject"]
      @sent_on      = Time.now
      @content_type = "text/html"
      @body[:url]     = url
      @body[:comment] = comment
    end

end
