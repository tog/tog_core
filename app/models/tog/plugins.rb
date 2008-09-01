module Tog
  module Plugins
    def self.settings(plugin, setting)
     if setting.is_a? Hash
       setting.each_pair{|k,v| Tog::Config["plugins.#{plugin}.#{k.to_s}"] ||= v }
     else
       Tog::Config["plugins.#{plugin}.#{setting.to_s}"]
     end
    end  
    def self.observers           
      Desert::Rails::Observer.observers
    end
  end
end