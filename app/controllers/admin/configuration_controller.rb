class Admin::ConfigurationController < Admin::BaseController
  
  def index
    @config_items = Tog::Config.find(:all, :order => '"key" desc')
  end
  
  def update
    params[:config].each do |key, value|
      Tog::Config[key] = value
    end
    flash[:ok] = "Configuration successfully changed."
    
    redirect_to :action => :index
  end
end
