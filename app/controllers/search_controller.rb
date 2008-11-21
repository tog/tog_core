class SearchController < ApplicationController

  def search
    @term = params[:global_search_field]
    @matches = Tog::Search.search(@term)
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @matches }
    end
  end
  
end
