class Admin::BaseController < ApplicationController
  layout "admin"

  before_filter :login_required
  #before_filter :set_meta_javascripts_and_stylesheets

  private

  def authorized?
    admin? 
  end

  #def set_meta_javascripts_and_stylesheets
  #  @stylesheets += %w(meta/meta)
  #end  
end
