require 'simpleton'
module Tog
  #
  # Tog::Search provides a simple interface to site-wide searches through a flexible collection of +sources+
  # that the developer can extend to plug its own classes on the general search.
  #
  # ==== Simple example
  #
  #   Tog::Search.sources << User
  #   @results = Tog::Search.search("joe-theplumber") # the @results instance will be paginated
  #
  # The modules used as +sources+ should implement a class method called search(query, search_options={}) and
  # should return an +Array+ instance.
  class Search
    include Simpleton
    attr_accessor :sources

    def initialize
      @sources = []
    end

    # This method iterates all the classes/modules (usually activerecord models) added to the +sources+ attribute.
    # For each class, its search method is called and the matches are added to the paginated collection of 
    # final results.
    #
    # ==== Attributes
    #
    # * <tt>:search_options</tt> - search options.
    # * <tt>:paginate_options</tt> - The same options allowed for the +paginate+ method provided by will_paginate
    #
    def search(query, search_options = {}, paginate_options = {})
      results = []
      @sources.each{|source|
        if source.respond_to?(:search)
          results << source.search(query, search_options)
        else
          RAILS_DEFAULT_LOGGER.warn(<<-WARNING

*********************************************************************************************************************************************
SEARCH WARNING: The source #{source} should implement a ´self.search(query, search_options={})´ method to be available on site-wide searches.
*********************************************************************************************************************************************

          WARNING
          )
        end
      }
      results.flatten.paginate(paginate_options)
    end
  end
end