class AddRefererToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :referer, :string
  end

  def self.down
    remove_column :comments, :referer
  end
end