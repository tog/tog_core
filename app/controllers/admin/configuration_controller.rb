class Admin::ConfigurationController < Admin::BaseController
  
  def index
    @config_items = Tog::Config.find(:all, :order => '"key" desc')
  end
  
  def update
    params[:config].each do |key, value|
      Tog::Config[key] = value
    end
    flash[:ok] = I18n.t("tog_core.admin.configuration.changed")
    
    if Rails.configuration.action_controller.perform_caching == true
      Rails.cache.delete('Tog::Config')
    end    
    
    redirect_to :action => :index
  end
end
