class CreateTogConfig < ActiveRecord::Migration
  def self.up
    create_table "config", :force => false do |t|
      t.string :key,   :limit => 255, :default => "", :null => false
      t.string :value
      t.timestamps
    end
    add_index "config", ["key"], :name => "key", :unique => true
  end

  def self.down
    drop_table "config"
  end
end
