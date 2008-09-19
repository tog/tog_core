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
    # todo Put flash message
    redirect_to @abuse.referer
  end
end