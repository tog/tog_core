module I18nHelper

  def supported_languages_for_select
    TogSupportedLanguages::LANGUAGES.collect{ |k, v| [v[:native_name].to_s, v[:iso_639_1].to_s] }
  end
    
  def supported_languages(&block)
    TogSupportedLanguages::LANGUAGES.each_pair do |k,v|
      yield v
    end
  end
  
end
