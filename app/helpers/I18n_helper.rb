module I18nHelper
  
  def supported_languages(&block)
    TogSupportedLanguages::LANGUAGES.each_pair do |k,v|
      yield v
    end
  end
  
end