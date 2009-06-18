class LocaleController < ApplicationController
  def set
    locale = params[:locale]                
    if locale && is_locale_available(locale)
      self.current_user_locale = locale
    end       
    redirect_to request.referer || root_path
  end
end