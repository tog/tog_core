require 'strscan'

module I18n
  module Backend
    class Simple
      INTERPOLATION_RESERVED_KEYS = %w(scope default)
      MATCH = /(\\\\)?\{\{([^\}]+)\}\}/

      def load_translations(*filenames)
        filenames.each {|filename| load_file filename }
      end
      
      def store_translations(locale, data)
        merge_translations(locale, data)
      end
      
      def translate(locale, key, options = {})
        raise InvalidLocale.new(locale) if locale.nil?
        return key.map{|k| translate locale, k, options } if key.is_a? Array

        reserved = :scope, :default
        count, scope, default = options.values_at(:count, *reserved)
        options.delete(:default)
        values = options.reject{|name, value| reserved.include? name }

        entry = lookup(locale, key, scope) || default(locale, default, options) || raise(I18n::MissingTranslationData.new(locale, key, options))
        entry = pluralize locale, entry, count
        entry = interpolate locale, entry, values
        entry
      end
      
      def localize(locale, object, format = :default)
        raise ArgumentError, "Object must be a Date, DateTime or Time object. #{object.inspect} given." unless object.respond_to?(:strftime)
        
        type = object.respond_to?(:sec) ? 'time' : 'date'
        formats = translate(locale, :"#{type}.formats")
        format = formats[format.to_sym] if formats && formats[format.to_sym]
        format = format.to_s.dup

        format.gsub!(/%a/, translate(locale, :"date.abbr_day_names")[object.wday]) 
        format.gsub!(/%A/, translate(locale, :"date.day_names")[object.wday])
        format.gsub!(/%b/, translate(locale, :"date.abbr_month_names")[object.mon])
        format.gsub!(/%B/, translate(locale, :"date.month_names")[object.mon])
        format.gsub!(/%p/, translate(locale, :"time.#{object.hour < 12 ? :am : :pm}")) if object.respond_to? :hour
        object.strftime(format)
      end
      
      protected
        
        def translations
          @translations ||= {}
        end
        def lookup(locale, key, scope = [])
          return unless key
          keys = I18n.send :normalize_translation_keys, locale, key, scope
          keys.inject(translations){|result, k| result[k.to_sym] or return nil }
        end
        def default(locale, default, options = {})
          case default
            when String then default
            when Symbol then translate locale, default, options
            when Array  then default.each do |obj| 
              result = default(locale, obj, options.dup) and return result
            end and nil
          end
        rescue MissingTranslationData
          nil
        end
        def pluralize(locale, entry, count)
          return entry unless entry.is_a?(Hash) and count
          # raise InvalidPluralizationData.new(entry, count) unless entry.is_a?(Hash)
          key = :zero if count == 0 && entry.has_key?(:zero)
          key ||= count == 1 ? :one : :other
          raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
          entry[key]
        end
        def interpolate(locale, string, values = {})
          return string unless string.is_a?(String)

          string = string.gsub(/%d/, '{{count}}').gsub(/%s/, '{{value}}')

          if string.respond_to?(:force_encoding)
            original_encoding = string.encoding
            string.force_encoding(Encoding::BINARY)
          end

          result = string.gsub(MATCH) do
            escaped, pattern, key = $1, $2, $2.to_sym

            if escaped
              pattern
            elsif INTERPOLATION_RESERVED_KEYS.include?(pattern)
              raise ReservedInterpolationKey.new(pattern, string)
            elsif !values.include?(key)
              raise MissingInterpolationArgument.new(pattern, string)
            else
              values[key].to_s
            end
          end

          result.force_encoding(original_encoding) if original_encoding
          result
        end
        
        def load_file(filename)
          type = File.extname(filename).tr('.', '').downcase
          raise UnknownFileType.new(type, filename) unless respond_to? :"load_#{type}"
          data = send :"load_#{type}", filename # TODO raise a meaningful exception if this does not yield a Hash
          data.each{|locale, d| merge_translations locale, d }
        end
        
        def load_rb(filename)
          eval IO.read(filename), binding, filename
        end
        
        def load_yml(filename)
          YAML::load IO.read(filename)
        end
        
        def merge_translations(locale, data)
          locale = locale.to_sym
          translations[locale] ||= {}
          data = deep_symbolize_keys data

          # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
          merger = proc{|key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
          translations[locale].merge! data, &merger
        end
        
        def deep_symbolize_keys(hash)
          hash.inject({}){|result, (key, value)|
            value = deep_symbolize_keys(value) if value.is_a? Hash
            result[(key.to_sym rescue key) || key] = value
            result
          }
        end
    end
  end
end
