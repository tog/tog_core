module Interface
  class DuplicateTabNameError < StandardError; end
  
  # Through Tog::Interface you can build the tabs/subtab navigation structure.
  # There are 3 main sections defined by default in tog: admin, member and site 
  # and you can add tabs/subtabs to any of them. 
  # These sections are oriented to the following kinds of users:
  #  * admin => users with admin privileges
  #  * member => users with an account on the social network
  #  * site => regular web visits without an account on the network
  # By default the tab names are i18n strings based in the key you give
  # them in the creation following the convention key.to_s.downcase.gsub(/ /, '_') and
  # appending "_items" for the subnav items
  # 
  # ==== Examples
  #
  #   Tog::Interface.sections(:admin).add "Manage", "/admin/configuration"
  #   # key used for translation => "en.interface.admin.manage"
  #   Tog::Interface.sections(:admin).add "My Tab", "/admin/mytab"
  #   # key used for translation => "en.interface.admin.my_tab"
  #   Tog::Interface.sections(:admin).add :test, "/admin/test"
  #   # key used for translation => "en.interface.admin.test"
  #
  #   # ... and for subnav items....
  #
  #   tab.add_item "Configuration", "/admin/configuration"
  #   # key used for translation => "en.interface.admin.manage_items.configuration"
  def self.sections(section=:site)
   case section
   when :site
     @site_tabset ||= TabSet.new(section)
   when :member
     @member_tabset ||= TabSet.new(section)
   when :admin
     @admin_tabset ||= TabSet.new(section)
   end
  end
  def self.symbolize_tab_key(section, key)
    "interface.#{section.to_s}.#{Tog::Interface.underscorize(key)}"
  end
  def self.underscorize(string)
    string.to_s.downcase.gsub(/ /, '_')
  end
  class Tab
    attr_accessor :key, :url, :items

    def initialize(set, key, url, options = {})
      @set, @key, @url = set, key, url
      @items = []
      @visibility = [options[:for], options[:visibility]].flatten.compact
      @visibility = [:all] if @visibility.empty?
    end

    def shown_for?(user)
      visibility.include?(:all) or
        visibility.any? { |role| user.send("#{role}?") }
    end

    def add_item(name, url)
      item_key = "#{key}_items.#{Tog::Interface.underscorize(name)}"
      @items << [item_key, url]
    end

    def include_url?(url)
      @url==url || @items.flatten.include?(url)
    end

  end


  class TabSet
    include Enumerable
    attr_accessor :name

    def initialize(name)
      @tabs = []
      @name = name
    end

    def add(key, url, options = {})
      options.symbolize_keys!
      before = options.delete(:before)
      after = options.delete(:after)
      tab_position = before || after

      key = Tog::Interface.symbolize_tab_key(@name, key)
      if tabs(key)
        raise DuplicateTabNameError.new("duplicate tab key #{key}")
      else
        tab = Tab.new(self, key, url, options)
        if tab_position
          index = @tabs.index(tabs(tab_position))
          index += 1 if before.nil?
          @tabs.insert(index, tab)
        else
          @tabs << tab
        end
        tab
      end
    end

    def remove(key)
      @tabs.delete(tabs(key))
    end

    def size
      @tabs.size
    end

    def tabs(key = :all_tabs)
      if key==:all_tabs
        @tabs
      else
        @tabs.find { |tab| 
          tab.key == Tog::Interface.symbolize_tab_key(@name, key)
        }
      end
    end

    def clear
      @tabs.clear
    end
    
    protected

  end

end
