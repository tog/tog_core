class ApplicationController < ActionController::Base
  around_filter :retardase_inhibitor
  before_filter :set_javascripts_and_stylesheets

  def set_javascripts_and_stylesheets
    @javascripts = ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES | %w(application)
    @stylesheets = %w()
    @feeds = %w()
  end
  
end
