require 'simpleton'
module Tog
  class Search
    include Simpleton
    attr_accessor :sources
    
    def initialize
      @sources = []
    end

    def search(query)
      results = []
      @sources.each{|source|
        results << source.search(query) if source.respond_to? :search
      }
      results
    end
  end
  class SearchResult
    attr_accessor :klass, :id, :title, :description
    
    def initialize(klass, id, title, description)
      @klass, @id, @title, @description = klass, id, title, description
    end
  end
end


#Tog::Search.sources << User
#
#@results = Tog::Search.search("ipod")
#
#class Course << ActiveRecord::Base
#  def search(query)
#    results = []
#    users = User.find(all, ['name LIKE ?', "%#{query}%"])
#    users.each {|user| }
#  end
#end