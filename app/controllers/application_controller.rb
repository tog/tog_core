class ApplicationController < ActionController::Base
  include InternationalizationSystem
  
  around_filter :retardase_inhibitor
  before_filter :set_javascripts_and_stylesheets

  def set_javascripts_and_stylesheets
    @javascripts = ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES | %w(application)
    @stylesheets = %w()
    @feeds = %w()
  end
  
  before_filter :set_locale
  def set_locale       
    I18n.locale = current_user_locale
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
end
