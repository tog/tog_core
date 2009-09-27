class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    <% plugins.each do |p| %>
      migrate_plugin "<%= p[0] %>", <%= p[1][1] %>
    <% end %>
  end

  def self.down
    <% plugins.reverse.each do |p| %>
      migrate_plugin "<%= p[0] %>", <%= p[1][0] %>
    <% end %>
  end
end