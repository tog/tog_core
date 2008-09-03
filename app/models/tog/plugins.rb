#module Tog
#  module Plugins
#    def self.settings(plugin, setting)
#     if setting.is_a? Hash
#       setting.each_pair{|k,v| Tog::Config.init_with("plugins.#{plugin}.#{k.to_s}", v) }
#     else
#       Tog::Config["plugins.#{plugin}.#{setting.to_s}"]
#     end
#    end
#  end
#end
#
module Tog
  module Plugins
    def self.settings(plugin, settings, options={})
     options.reverse_merge! :force => :false
     
     if settings.is_a? Hash
       if options[:force]
         settings.each_pair{|k,v| Tog::Config.init_with("plugins.#{plugin}.#{k.to_s}", v) }
       else
         settings.each_pair{|k,v| Tog::Config["plugins.#{plugin}.#{k.to_s}"] = v }
       end
     else
       Tog::Config["plugins.#{plugin}.#{settings.to_s}"]
     end
    end  
    def self.observers           
      Desert::Rails::Observer.observers
    end
  end
end