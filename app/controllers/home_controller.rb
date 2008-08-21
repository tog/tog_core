class HomeController < ApplicationController
  
  layout "site"
  helper :core  
  
  def index

    @warning = "dedwe"

    #flash[:notice] = "ffwefwe"
    #flash[:ok] = "ffwefwe"
    #flash[:warning] = "ffwefwe"
    #flash[:error] = "ffwefwe"
    
  end
end
