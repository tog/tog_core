module CoreHelper
  def render_flash_messages
    flash.collect{|entry|
      content_tag(:div, entry[1], :class => "notice #{entry[0]}")
    }
  end

  def config
    Tog::Config
  end

  def inject_autodiscovery
    @feeds.uniq.collect{ |feed|
      auto_discovery_link_tag feed[0], feed[1], feed[2]
    }.join("\n")
  end

  def include_autodiscovery(type = :rss, url_options = {}, tag_options = {})
    @feeds << [type, url_options, tag_options]
  end
end
