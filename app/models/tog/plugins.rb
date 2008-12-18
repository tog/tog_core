module Plugins
  # Access to Tog::Config system through the namespaced +plugin+ value.
  # The +settings+ will accept a hash of values and they'll be stored as settings in
  # the form of +"plugins.#{plugin}.#{settings}"+ in the config table.
  # Additionnally you can use the +options+ hash to tweak certain default behaviours.
  #
  # ==== Options
  # * <tt>:force => boolean</tt> - This can be used to overwrite a given setting.
  #   Defaults to false.
  #
  # ==== Examples
  #
  #   Tog::Plugins.settings :test_plugin, :key => "value", :key2 => "value2"
  #   # => {:key2=>"value2", :key=>"value"}
  #   Tog::Plugins.settings :test_plugin, :key
  #   # => "value"
  #   Tog::Plugins.settings :test_plugin, {:key => "value2"}, {:force => true}
  #   # => {:key=>"value2"}
  #   Tog::Plugins.settings :test_plugin, :key
  #   # => "value2"
  def self.settings(plugin, settings={}, options={})
   options.reverse_merge! :force => false
   if settings.is_a? Hash
     unless options[:force]
       settings.each_pair{|k,v| Tog::Config.init_with("plugins.#{plugin}.#{k.to_s}", v) }
     else
       settings.each_pair{|k,v| Tog::Config["plugins.#{plugin}.#{k.to_s}"] = v }
     end
   else
     Tog::Config["plugins.#{plugin}.#{settings.to_s}"]
   end
  end

  # Retrieve the observers defined on plugins initialization through the desert mechanism
  def self.observers
    Desert::Rails::Observer.observers
  end

  # Makes a given list of helper modules available to all the views in the app defining them
  # as helpers on ActionController::Base
  def self.helpers(*args)
    args.flatten.each do |hlp|
      case hlp
        when Module
          ActionController::Base.helper hlp
        else
          raise ArgumentError, "helpers expects a Module argument (was: #{args.inspect})"
      end
    end
  end

  # Tog::Plugins.storage_options
  def self.storage_options
    storage = Tog::Config['plugins.tog_core.storage']
    case storage.downcase
    when "s3"
      Tog::S3.options_for_paperclip
    when "filesystem"
      {:storage => "filesystem", :path => Tog::Config['plugins.tog_core.storage.filesystem.path']}
    end
  end

end