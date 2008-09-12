module Interface
  class DuplicateTabNameError < StandardError; end

  def self.sections(section=:site)
   case section
   when :site
     @site_tabset ||= TabSet.new
   when :member 
     @member_tabset ||= TabSet.new
   when :admin
     @admin_tabset ||= TabSet.new
   end
  end

  class Tab
    attr_accessor :name, :url, :items
    
    def initialize(name, url, options = {})
      @name, @url = name, url
      @items = []
      @visibility = [options[:for], options[:visibility]].flatten.compact
      @visibility = [:all] if @visibility.empty?
    end
    
    def shown_for?(user)
      visibility.include?(:all) or
        visibility.any? { |role| user.send("#{role}?") }
    end
    
    def add_item(name, url)
      @items << [name, url]
    end
    
  end
  
  
  class TabSet
    include Enumerable

    def initialize
      @tabs = []
    end

    def add(name, url, options = {})
      options.symbolize_keys!
      before = options.delete(:before)
      after = options.delete(:after)
      tab_name = before || after
      if tabs(name)
        raise DuplicateTabNameError.new("duplicate tab name `#{name}'")
      else
        if tab_name
          index = @tabs.index(tabs(tab_name))
          index += 1 if before.nil?
          @tabs.insert(index, Tab.new(name, url, options))
        else
          @tabs << Tab.new(name, url, options)
        end
      end
    end
    
    def remove(name)
      @tabs.delete(tabs(name))
    end
    
    def size
      @tabs.size
    end
    
    def tabs(name = :all_tabs)
      if name==:all_tabs
        @tabs
      else
        @tabs.find { |tab| tab.name == name }
      end
    end
    
    def clear
      @tabs.clear
    end
    
  end
  
end 
