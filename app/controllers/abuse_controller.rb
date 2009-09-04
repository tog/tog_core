class AbuseController < ApplicationController
  def new
     @abuse = Abuse.new
     @abuse.referer = request.referer || "" 
     @abuse.resource_type = params[:resource_type]
     @abuse.resource_id   = params[:resource_id]
  end
  def create
    @abuse = Abuse.new(params[:abuse])
    @abuse.save!              
    flash[:ok] = I18n.t("tog_core.site.abuses.added")
    redirect_to @abuse.referer
  end
end