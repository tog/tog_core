class Comment < ActiveRecord::Base
  def by_anonymous?
    user.blank? && name.blank? && url.blank? && email.blank?
  end

  def by_user?
    !user.blank?
  end

  def by_visitor?
    user.blank? && (!name.blank? || !url.blank? || !email.blank?)
  end

  def author_name
    if by_user?
      user.login
    elsif by_visitor? && !name.blank?
      name
    else
      "Anonymous"
    end
  end

  def author_email
    if by_user?
      user.email
    elsif by_visitor?
      email
    end
  end
  def commentable_owner
    commentable.owner if commentable 
  end
  def commentable_owner_email
    commentable.owner.email if commentable && commentable.owner
  end
  def commentable_title
    commentable.title_for_comment
  end
end