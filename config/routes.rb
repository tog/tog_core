# Add your custom routes here.  If in config/routes.rb you would
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

root :controller => "home"

with_options(:controller => 'search') do |search|
  search.do_search 'search', :action => 'search'
end

with_options(:controller => 'comments') do |comment|
  comment.comment 'comments', :action => 'create'
end

with_options(:controller => 'abuse') do |abuse|
  abuse.report_abuse            'report_abuse', :action => 'new',    :conditions => { :method => :get }
  abuse.report_abuse_with_model 'report_abuse/:resource_type/:resource_id',    :action => 'new',    :conditions => { :method => :get }
  abuse.report_abuse_create     'report_abuse',    :action => 'create', :conditions => { :method => :post }
end

namespace(:admin) do |admin|
  admin.with_options(:controller => 'dashboard') do |home|
    home.dashboard  '/',  :action => 'index'
  end
  admin.with_options(:controller => 'configuration') do |config|
    config.configuration '/configuration', :action => 'index'
    config.configuration_update '/configurator/update', :action => 'update'    
  end
  admin.with_options(:controller => 'abuses_manager') do |manage|
    manage.abuses_index   '/manage_abuses'    ,          :action => 'index'
    manage.abuses_show    '/manage_abuses/:id',          :action => 'show'
    manage.abuses_confirm '/manage_abuses/:id/confirm',  :action => 'confirm'
  end
  admin.resources :users
end

namespace(:member) do |member|
  member.with_options(:controller => 'dashboard') do |home|
    home.dashboard  '/',  :action => 'index'
  end
  member.with_options(:controller => 'comments') do |comment|
    comment.comment_approve 'comments/:id/approve', :action => 'approve'
    comment.comment_remove  'comments/:id/remove',  :action => 'remove'
  end
  member.with_options(:controller => 'users') do |user|
    user.my_account       '/account',         :action => 'my_account'
    user.destroy_account  '/destroy',         :action => 'destroy'
    user.change_password  '/change_password', :action => 'change_password', :conditions => { :method => :post }
  end
  member.with_options(:controller => 'rates') do |rate|
    rate.rate '/rate',  :action=>'create'
  end
end