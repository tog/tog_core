module CoreHelper
  include CommentsHelper
  include InterfaceHelper
  include AbuseHelper
  include UsersHelper
  include SearchHelper
  include RatesHelper
  include WillPaginate::ViewHelpers  
  
  def config
    Tog::Config
  end

  def inject_js
    @javascripts.uniq.collect{ |js|
      javascript_include_tag js
    }.join("\n")
  end

  def inject_css
    @stylesheets.uniq.collect{ |css|
      stylesheet_link_tag css
    }.join("\n")
  end

  def inject_autodiscovery
    @feeds.uniq.collect{ |feed|
      auto_discovery_link_tag feed[0], feed[1], feed[2]
    }.join("\n")
  end

  def include_stylesheet(css)
    @stylesheets << css
  end

  def include_javascript(js)
    @javascripts << js
  end

  def include_autodiscovery(type = :rss, url_options = {}, tag_options = {})
    @feeds << [type, url_options, tag_options]
  end



  def clean(url)
    uri = URI.parse(url)
    uri.path.gsub(%r{/+}, '/').gsub(%r{/$}, '')
  end


  def public_continuum(size = 40)
    Activity.find(:all, :limit=> size, :order => " created_at DESC").collect{|a|
      content_tag :li, :class => "clearfix" + cycle(nil, " pair") do 
        profile = content_tag :div, :class => "image" do 
          link_to icon_for_profile(a.user.profile, 'tiny'), profile_path(a.user.profile)
        end
        text = content_tag :div, :class => "text" do 
          " #{link_to(a.user.profile.full_name, profile_path(a.user.profile))} generated action '#{a.action}' on #{a.item_type}##{a.item_id} "
        end
        profile + text
      end
    }
  end
  
  

  def will_paginate_with_i18n(collection, options = {})
    will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t("will_paginate.previous"), :next_label => I18n.t("will_paginate.next") ))
  end
  alias_method_chain :will_paginate, :i18n
  
end
