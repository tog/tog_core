module CoreHelper
  def render_flash_messages
    flash.collect{|entry|
      content_tag(:div, entry[1], :class => "notice #{entry[0]}")
    }
  end

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

  def links_for_navigation(section)
    tabs = Tog::Interface.sections(section).tabs
    links = tabs.map do |tab|
      nav_link_to(tab)
    end.compact
  end

  def current_url?(options)
    url = case
    when Hash
      url_for options
    else
      options.to_s
    end
    request.request_uri =~ Regexp.new('^' + Regexp.quote(clean(url)))
  end

  def clean(url)
    uri = URI.parse(url)
    uri.path.gsub(%r{/+}, '/').gsub(%r{/$}, '')
  end

  def nav_link_to(tab)
    if current_url?(tab.url)
      content_tag(:li, %{#{link_to tab.name, tab.url} #{sub_nav_links_to(tab.items)}}, :class=>"on")
    else
      content_tag(:li, link_to(tab.name, tab.url))
    end
  end

  def sub_nav_links_to(tabs)
    unless tabs.empty?
      content_tag :ul do
        tabs.collect do |t|
          %{<li #{"class=\"on\"" if current_url?(t[1])}>#{ link_to t[0], t[1]}</li>}
        end
      end
    end
  end

  def comment_user_name(comment)
    if comment.by_user?
      comment.user.login
    elsif comment.by_visitor? && !comment.name.blank?
      comment.name
    else 
      "Anonymous"
    end
  end

  
  def public_continuum
    Activity.find(:all, :limit=> 40, :order => " created_at DESC").collect{|a|
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
end
