class SearchController < ApplicationController

  def search
    @page = params[:page] || '1'
    @term = params[:global_search_field]
    @matches = Tog::Search.search(@term, {}, {:page => @page})
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @matches }
    end
  end
  
end
