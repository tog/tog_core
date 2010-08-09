class Admin::CommentsController < Admin::BaseController

  def index
    conditions = nil
    if params[:spam] && params[:status]
      conditions = ['spam = ? and approved = ?', params[:spam] == "true", params[:status] == "true"]
    elsif params[:spam]
      conditions = ['spam = ?', params[:spam] == "true"]
    elsif params[:status]
      conditions = ['approved = ?', params[:status] == "true"]
    end
      
    @comments = Comment.all(:conditions => conditions, :order => "created_at desc").paginate :page => params[:page], 
                            :per_page => Tog::Config['plugins.tog_core.pagination_size']
                                   
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def approve
    comment = Comment.find(params[:id])
    comment.approved = true
    comment.save
    redirect_to admin_comment_path(comment)
  end
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:ok]= I18n.t("tog_core.admin.comments.deleted")
    redirect_to admin_comments_path
  end  

end