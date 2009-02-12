module Deprecation # :nodoc:
  extend ActiveSupport::Deprecation

  def self.warn(message, callstack = caller)
    message = '[TOG] ' + message.strip.gsub(/\s+/, ' ')
    ActiveSupport::Deprecation.warn(message, callstack)
  end
end