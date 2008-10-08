class CreateTogConfig < ActiveRecord::Migration
  def self.up
    # Since we've had problems with the proper moment to create the config table
    # we've moved the process of manage the table existence to a internal method
    # Called create_tog_config_table on Tog::Config. So for now... nothing to see
    # here. Move on. Please. Now.
  end

  def self.down
  end
end
