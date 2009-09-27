class UpdateTogMigrationGenerator < Rails::Generator::Base
      
  def manifest
    record do |m|

      require File.expand_path(File.join(RAILS_ROOT, "config","environment"))
      tog_plugins = plugin_roots(ENV["PLUGIN"])
      
      exists_migrations_table = ActiveRecord::Base.connection.tables.include?('plugin_schema_migrations')

      upgradable_plugins = Hash.new
      tog_plugins.each do |directory|
        name = File.basename(directory)
        max_version = max_migration_number(directory)
        Desert::PluginMigrations::Migrator.current_plugin = Desert::Manager.find_plugin(name)
        current_version = exists_migrations_table ? Desert::PluginMigrations::Migrator.current_version : 0
        upgradable_plugins[name] = [current_version, max_version] if max_version > current_version
      end
     
      if upgradable_plugins.empty?
        puts "Nothing to update."
      else
        #migration name prefix
        migration_file_name = exists_migrations_table ? "upgrade" : "install"        
        #migration name body
        migration_file_name += upgradable_plugins.keys.size > 1 ? "_tog_plugins" : "_#{upgradable_plugins.keys.first}"
        #migration name sufix
        migration_file_name += "_#{Time.now.strftime('%Y%m%d%H%M%S')}"
        
        #tog_user first, mainly for first installation
        plugins =  upgradable_plugins.sort {|a,b| 1 if a[0] == 'tog_user' || a[0]<=>b[0]}
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
           :migration_name => migration_file_name.camelize,
           :plugins => plugins
        }, :migration_file_name => migration_file_name
      end
    end
  end
  
  protected 
  
  def plugin_roots(plugin=nil)
    roots = Dir[File.join(RAILS_ROOT, 'vendor', 'plugins', 'tog_*')]
    if plugin
      roots = roots.select {|x| /\/(\d+_)?#{plugin}$/ === x }
      if roots.empty?
        puts "Sorry, the plugin '#{plugin}' is not installed."
      end
    end
    roots
  end
  def max_migration_number(plugin)
    to_version=Dir.glob("#{plugin}/db/migrate/*.rb").inject(0) do |max, file_path|
      n = File.basename(file_path).split('_', 2).first.to_i
      if n > max then n else max end
    end
  end  
end