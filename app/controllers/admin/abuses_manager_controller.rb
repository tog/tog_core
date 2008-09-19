class Admin::AbusesManagerController < Admin::BaseController
  def index  
    @abuses = Abuse.find(:all, :order => "created_at DESC")                
  end           
  def show
    @abuse = Abuse.find(params[:id])
  end
  def confirm
    @abuse = Abuse.find(params[:id])
    @abuse.confirm!
  end
end
