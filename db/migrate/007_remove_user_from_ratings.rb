class RemoveUserFromRatings < ActiveRecord::Migration

  def self.up
    remove_column :ratings, :user_id
  end

  def self.down
    add_column :ratings, :user_id, :integer
  end
  
end