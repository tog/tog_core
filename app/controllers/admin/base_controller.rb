class Admin::BaseController < ApplicationController
  layout "admin"

  before_filter :login_required

  private

  def authorized?
    admin? 
  end

end
