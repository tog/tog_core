module UsersHelper
  
  def last_users(limit=16)
    User.find(:all,:conditions => ["state = ?", 'active'],:limit => limit,:order => 'created_at desc')
  end
  
end