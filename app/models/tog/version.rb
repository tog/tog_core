module Tog
  module Version
    Major = '0'
    Minor = '1'
    Tiny  = '1'
    # http://en.wikipedia.org/wiki/Moons_of_Jupiter
    Codename = 'Adrastea'
    class << self
      def to_s
        [Major, Minor, Tiny].join('.')
      end
      def full_version
        "#{[Major, Minor, Tiny].join('.')} #{Codename}"
      end
      alias :to_str :to_s
    end
  end
end