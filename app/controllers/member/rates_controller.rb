class Member::RatesController < Member::BaseController

  def create
    type = params[:type]
    id = params[:id]
    rateable = type.constantize.find(id)
    
    if(!rateable.ratings.include?(Rating.find_by_user_id(current_user.id)))
      rating = rateable.rate params[:rate]
      rating.user_id = current_user.id
      if rating.save
        flash[:ok] = I18n.t("tog_core.site.rating.added")
      else
        flash[:error] = I18n.t("tog_core.site.rating.error")
      end
    else
      flash[:error] = I18n.t("tog_core.site.rating.already_rated")
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end
end
