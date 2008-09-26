module UrlWriterRetardaseInhibitor
  module ActionController
    def self.included(ac)
      ac.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def retardase_inhibitor
        begin
          request = self.request
          ::ActionController::UrlWriter.module_eval do
            @old_default_url_options = default_url_options.clone
            default_url_options[:host] = request.host
            #default_url_options[:port] = request.port unless request.port == 80
            default_url_options[:port] = request.port
            default_url_options.delete(:port) if request.port == 80 || request.port == 443
            protocol = /(.*):\/\//.match(request.protocol)[1] if request.protocol.ends_with?("://")
            default_url_options[:protocol] = protocol
          end
          yield
        ensure
          ::ActionController::UrlWriter.module_eval do
            default_url_options[:host] = @old_default_url_options[:host]
            default_url_options[:port] = @old_default_url_options[:port]
            default_url_options[:protocol] = @old_default_url_options[:protocol]
          end
        end
      end
    end
  end

  module ActionMailer
    def self.included(am)
      am.send(:include, ::ActionController::UrlWriter)
      ::ActionController::UrlWriter.module_eval do
        default_url_options[:host] = Tog::Plugins.settings :tog_core, 'host.name'
        default_url_options[:port] = Tog::Plugins.settings :tog_core, 'host.port'
        default_url_options[:protocol] = 'http'
      end
    end
  end
end

ActionController::Base.send(:include, UrlWriterRetardaseInhibitor::ActionController)
ActionMailer::Base.send(:include, UrlWriterRetardaseInhibitor::ActionMailer)
