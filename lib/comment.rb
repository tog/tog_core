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
end