class Admin::AbusesManagerController < Admin::BaseController
  def index  
    @abuses = Abuse.paginate :per_page => Tog::Config['plugins.tog_core.pagination_size'], :page => params[:page], :order => :created_at
  end           
  def show
    @abuse = Abuse.find(params[:id])
  end
  def confirm
    @abuse = Abuse.find(params[:id])
    @abuse.confirm!
  end
end
