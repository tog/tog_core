# Array of plugins with Application model dependencies.
reloadable_plugins = ["acts_as_commentable", "acts_as_scribe", "acts_as_taggable"]

# Force these plugins to reload, avoiding stale object references.
reloadable_plugins.each do |plugin_name|
  reloadable_path = RAILS_ROOT + "/vendor/plugins/#{plugin_name}/lib"
  ActiveSupport::Dependencies.load_once_paths.delete(reloadable_path)
end