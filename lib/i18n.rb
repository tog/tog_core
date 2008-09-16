# Authors::   Matt Aimonetti (http://railsontherun.com/),
#             Sven Fuchs (http://www.artweb-design.de),
#             Joshua Harvey (http://www.workingwithrails.com/person/759-joshua-harvey),
#             Saimon Moore (http://saimonmoore.net),
#             Stephan Soller (http://www.arkanis-development.de/) 
# Copyright:: Copyright (c) 2008 The Ruby i18n Team
# License::   MIT

# TOG WARNING: This is backported from the future Rails 2.2 I18n module and will be required only if your application is pre-Rails 2.2 
require 'i18n/backend/simple'
require 'i18n/exceptions'

module I18n  
  @@backend = nil
  @@default_locale = 'en-US'
  @@exception_handler = :default_exception_handler
    
  class << self
    def backend
      @@backend ||= Backend::Simple.new
    end
    def backend=(backend) 
      @@backend = backend
    end
    def default_locale
      @@default_locale 
    end
    def default_locale=(locale) 
      @@default_locale = locale 
    end
    def locale
      Thread.current[:locale] ||= default_locale
    end
    def locale=(locale)
      Thread.current[:locale] = locale
    end
    def exception_handler=(exception_handler)
      @@exception_handler = exception_handler
    end
    def load_translations(*args)
      backend.load_translations(*args)
    end
    def translate(key, options = {})
      locale = options.delete(:locale) || I18n.locale
      backend.translate locale, key, options
    rescue I18n::ArgumentError => e
      raise e if options[:raise]
      send @@exception_handler, e, locale, key, options
    end        
    alias :t :translate
    
    def localize(object, options = {})
      locale = options[:locale] || I18n.locale
      format = options[:format] || :default
      backend.localize(locale, object, format)
    end
    alias :l :localize
    
  protected
    def default_exception_handler(exception, locale, key, options)
      return exception.message if MissingTranslationData === exception
      raise exception
    end
    def normalize_translation_keys(locale, key, scope)
      keys = [locale] + Array(scope) + [key]
      keys = keys.map{|k| k.to_s.split(/\./) }
      keys.flatten.map{|k| k.to_sym}
    end
  end
end


