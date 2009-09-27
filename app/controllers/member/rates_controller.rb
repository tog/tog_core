class Member::RatesController < Member::BaseController

  def create
    type = params[:type]
    id = params[:id]
    rateable = type.constantize.find(id)
    
    if rateable.rated_by?(current_user) == true
      flash[:error] = I18n.t("tog_core.site.rating.already_rated")
    else
      rateable.rate_it params[:rate], current_user
      flash[:ok] = I18n.t("tog_core.site.rating.added")
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end
end
