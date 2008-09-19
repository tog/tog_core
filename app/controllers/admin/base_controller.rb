class Admin::BaseController < ApplicationController
  layout "admin"

  before_filter :login_required, :distribution

  private

  def authorized?
    admin? 
  end
  
  def distribution
    @columns_distribution="col_80_20"
  end

end
