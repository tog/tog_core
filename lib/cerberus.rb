# Cerberus is the digital dog that will stop the spam in your app's door. To enable the spam checking you'll need to initialize a few settings on the tog_core plugin:
# 'spam.engine', 'spam.key' and 'spam.url'. This can be easily address via <pre>Tog::Plugins.settings :tog_core, 'spam.engine' => "value"</pre>.

class Cerberus

  # Returns a boolean indicating if the given comment is spam or not.
  def self.check_spam(comment, request)
    if Cerberus.spam_engine_enabled?
      engine = Cerberus.spam_engine
      return false unless engine.verified?

      result = engine.check_comment(
        :user_ip    => request.remote_ip,
        :user_agent => request.env['HTTP_USER_AGENT'],
        :referrer   => request.env['HTTP_REFERER'],
        :article_date => comment.commentable.created_at,
        :comment_type => 'comment',
        :comment_author => comment.author_name,
        :comment_author_email => comment.author_email,
        :comment_content => comment.comment
      )
      result[:spam]
    else
      false
    end

  end

  # Returns a boolean indicating if there is a spam engine configurated
  def self.spam_engine_enabled?
    !Tog::Plugins.settings(:tog_core, 'spam.engine').blank? &&
    !Tog::Plugins.settings(:tog_core, 'spam.key').blank?
  end

  # Returns a connection to the spam engine managed by Viking
  def self.spam_engine
    Viking.connect(Tog::Plugins.settings(:tog_core, 'spam.engine'),
                  :api_key => Tog::Plugins.settings(:tog_core, 'spam.key'),
                  :blog => Tog::Plugins.settings(:tog_core, 'spam.url'))
  end

end