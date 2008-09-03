# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

root :controller => "home"

with_options(:controller => 'comments') do |comment|    
  comment.comment         'comments',             :action => 'create'
  comment.comment_approve 'comments/:id/approve', :action => 'approve'    
  comment.comment_remove  'comments/:id/remove',  :action => 'remove'
end
