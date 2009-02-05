# Tog::Search provides a simple interface to site-wide searches through a flexible collection of +sources+
# that the developer can extend to plug its own classes on the general search.
#
# ==== Simple example
#
#   Tog::Search.sources << "User"
#   @results = Tog::Search.search("joe-theplumber") # the @results instance will be paginated
#
# The modules used as +sources+ should implement a class method called site_search(query, options={}) and
# should return an +Array+ instance.
module Search

  # The sources availables to search in. These sources must be strings representing classes o modules that can
  # be retrieved through <pre>source.constantize</pre>.
  def self.sources
    @sources ||= []
  end

  # This method iterates all the classes/modules (usually activerecord models) added to the +sources+ attribute.
  # For each class, its search method is called and the matches are added to the paginated collection of
  # final results.
  #
  # ==== Attributes
  #
  # * <tt>:options</tt> - search options.
  # * <tt>:paginate_options</tt> - The same options allowed for the +paginate+ method provided by will_paginate
  #
  # == Filter conditions
  #
  # Search may be limited to specific sources by declaring the sources to
  # include or exclude. Both options accept single sources
  # (<tt>:only => "Model1"</tt>) or arrays of sources
  # (<tt>:except => ["Model1", "Model2"]</tt>).
  #
  #  Tog::Search.search(term, :only => ["User","Course"])
  #  Tog::Search.search(term, :except => "ClubHouse")
  
  def self.search(query, options = {}, paginate_options = {})
    paginate_options.reverse_merge! :per_page => Tog::Config['plugins.tog_core.pagination_size']
    results = []
    sources.uniq.flatten.each{|name|
      begin
        source = name.constantize
        if source.respond_to?(:site_search)
          if included_in_search?(name, options)
            results << source.site_search(query, options) 
          end
        else
          RAILS_DEFAULT_LOGGER.warn(<<-WARNING

**************************************************************************************************************************************************
SEARCH WARNING: The source #{source} should implement a ´self.site_search(query, options={})´ method to be available on site-wide searches.
**************************************************************************************************************************************************

          WARNING
          )
        end

      rescue NameError => e
        RAILS_DEFAULT_LOGGER.error(<<-ERROR

**************************************************************************************************************************************************
SEARCH ERROR: The source #{name} can't be constantized. Double-check it and make sure there is a matching Class or Module.
**************************************************************************************************************************************************

        ERROR
        )

      end

    }
    results.flatten.paginate(paginate_options)
  end
  
  protected 
  
  def self.included_in_search?(source, options)
    if options[:only]
      options[:only].include?(source)
    elsif options[:except]
      !options[:except].include?(source)
    else
      true
    end
  end
end