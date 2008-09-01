class ApplicationController < ActionController::Base
  before_filter :set_javascripts_and_stylesheets

  helper :core

  def set_javascripts_and_stylesheets
    @javascripts = %w(prototype effects dragdrop controls application)
    @stylesheets = %w(base)
    @feeds = %w()
  end
end
