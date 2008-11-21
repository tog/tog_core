module SearchHelper
  
  def render_match_partial(match)
    begin
      klass = match.class.name.underscore
      render :partial => "search/#{klass}", :locals => { :match => match }
    rescue ActionView::MissingTemplate => e
      "Missing search template for model #{klass}. Create a search/_#{klass}.html.erb partial in the correct plugin and try again."
    rescue RuntimeError => e
      "Unable to find the class name of the following match #{debug match}"
    end
  end
  
end