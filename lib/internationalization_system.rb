module InternationalizationSystem
  protected
  
    def current_user_locale
      @current_user_locale ||= locale_from_session || locale_from_cookie || locale_from_browser || locale_from_settings
    end
    
    def current_user_locale=(locale)  
      session[:user_locale] = locale                                                           
      cookies[:user_locale] = { :value => locale, :expires => 2.weeks.from_now.utc }
      @current_user_locale = locale
    end                                  
    
    def locale_from_session 
      self.current_user_locale = session[:user_locale] if session[:user_locale]
    end
    
    def locale_from_cookie
      locale = cookies[:user_locale]
      if locale && is_locale_available(locale)
        self.current_user_locale = locale
      end
    end  
    
    def locale_from_browser    
      puts "#{request.user_preferred_languages}"
      locale = request.user_preferred_languages.first.scan(/^[a-z]{2}/).first rescue nil
      
      if locale && is_locale_available(locale)
        self.current_user_locale = locale
      end
    end  
    
    def locale_from_settings                                           
      self.current_user_locale = Tog::Config["plugins.tog_core.language.default"] || Tog::Config["plugins.tog_core.language.default"] = "en"
    end       
                               
    def is_locale_available(locale)
      I18n.available_locales.include? locale.to_sym
    end                               

    def self.included(base)
      base.send :helper_method, :current_user_locale
    end
    
end


# => Copyright (c) 2008 Iain Hecker, released under the MIT license   
# => http://github.com/iain/http_accept_language
module HttpAcceptLanguage

  def user_preferred_languages
    @user_preferred_languages ||= env['HTTP_ACCEPT_LANGUAGE'].split(',').collect do |l|
      l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
      l.split(';q=')
    end.sort do |x,y|
      raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
      y.last.to_f <=> x.last.to_f
    end.collect do |l|
      l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
    end
  rescue # Just rescue anything if the browser messed up badly.
    []
  end
  def preferred_language_from(array)
    (user_preferred_languages & array.collect { |i| i.to_s }).first
  end
  def compatible_language_from(array)
    user_preferred_languages.map do |x|
      x = x.to_s.split("-")[0]
      array.find do |y|
        y.to_s.split("-")[0] == x
      end
    end.compact.first
  end
end

if defined?(ActionController::Request)
  ActionController::Request.send :include, HttpAcceptLanguage
elsif defined?(ActionController::AbstractRequest)
  ActionController::AbstractRequest.send :include, HttpAcceptLanguage
else
  ActionController::CgiRequest.send :include, HttpAcceptLanguage
end
