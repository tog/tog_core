class SearchController < ApplicationController

  def search
    @matches = Tog::Search.search(params[:global_search_field])
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @matches }
    end
  end
  
end
