class HomeController < ApplicationController
  
  helper :core 
  helper :users
  helper :groups 
  
  def index

    @warning = "dedwe"

    #flash[:notice] = "ffwefwe"
    #flash[:ok] = "ffwefwe"
    #flash[:warning] = "ffwefwe"
    #flash[:error] = "ffwefwe"
    
  end
end
