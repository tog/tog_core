module CoreHelper

  def render_flash_messages
    flash.collect{|entry|
      content_tag(:div, entry[1], :class => "notice #{entry[0]}")
    }
  end
  def config
    Tog::Config
  end  
end
