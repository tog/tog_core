module Tog
module Version
  MAJOR = 0
  MINOR = 6
  TINY  = 0
  MODULE = "Europa"
  STRING = [MAJOR, MINOR, TINY].join('.')

  class << self
    def to_s
      STRING
    end
    def full_version
      "#{MODULE} #{STRING}"
    end
    alias :to_str :to_s
  end
end
end
