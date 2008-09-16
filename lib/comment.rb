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
end