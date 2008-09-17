class Member::BaseController < ApplicationController
  layout "member"

  before_filter :login_required

  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  private

  def bad_record
     render :template => "member/site/not_found"
  end

end