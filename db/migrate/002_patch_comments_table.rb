class PatchCommentsTable < ActiveRecord::Migration
  def self.up
    #change field size maintaining column value
    add_column :comments, :commentable_type_tmp, :string, :default => "", :null => false    
    Comment.update_all 'commentable_type_tmp = commentable_type'
    remove_column :comments, :commentable_type
    add_column :comments, :commentable_type, :string, :default => "", :null => false
    Comment.update_all 'commentable_type = commentable_type_tmp'
    remove_column :comments, :commentable_type_tmp
  end

  def self.down
  end
end
