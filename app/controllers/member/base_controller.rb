class Member::BaseController < ApplicationController
  layout "member"

  before_filter :login_required
  #before_filter :set_admin_javascripts_and_stylesheets

  helper :core  

  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  private

  #def set_admin_javascripts_and_stylesheets
  #  @stylesheets += %w(admin/admin)
  #end

  def bad_record
     render :template => "member/site/not_found"
  end

end