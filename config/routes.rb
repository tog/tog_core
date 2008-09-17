# Add your custom routes here.  If in config/routes.rb you would
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

root :controller => "home"

with_options(:controller => 'comments') do |comment|
  comment.comment         'comments',             :action => 'create'
  comment.comment_approve 'comments/:id/approve', :action => 'approve'
  comment.comment_remove  'comments/:id/remove',  :action => 'remove'
end

namespace(:admin) do |admin|
  admin.with_options(:controller => 'dashboard') do |home|
    home.dashboard  '/',  :action => 'index'
  end
  admin.with_options(:controller => 'configuration') do |config|
    config.configuration '/configuration', :action => 'index'
    config.configuration_update '/configurator/update', :action => 'update'    
  end
end

namespace(:member) do |member|
  member.with_options(:controller => 'dashboard') do |home|
    home.dashboard  '/',  :action => 'index'
  end
end