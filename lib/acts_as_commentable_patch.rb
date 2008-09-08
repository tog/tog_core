module Juixe
  module Acts
    module Commentable

      module ClassMethods
        def acts_as_commentable(attribute_for_title=nil)
          has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
          has_many :active_comments, :as => :commentable, :class_name => 'Comment', :conditions => ["approved = ?", true], :order => 'created_at ASC'
          has_many :pending_comments, :as => :commentable, :class_name => 'Comment', :conditions => ["approved = ?", false], :order => 'created_at ASC'

          write_inheritable_attribute(:attribute_for_title, attribute_for_title)
          class_inheritable_reader :attribute_for_title

          include Juixe::Acts::Commentable::InstanceMethods
          extend Juixe::Acts::Commentable::SingletonMethods
        end
      end

      module InstanceMethods
        def title_for_comment
          if (attribute_for_title.nil? || !self.respond_to?(attribute_for_title))
            begin
              string=self.title
            rescue
              begin
                string=self.name
              rescue
                raise("No attribute was specified for acts_as_commentable to use and 'name' and 'title' weren't available")
              end
            end
          else
            begin
              string = self.send(attribute_for_title)
            rescue
              raise("The attribute '#{attribute_for_title}' specified for acts_as_commentable don't exist on #{self.class.name}")
            end
          end
        end
      end

    end
  end
end

# Array of plugins with Application model dependencies.
reloadable_plugins = ["acts_as_commentable"]

# Force these plugins to reload, avoiding stale object references.
reloadable_plugins.each do |plugin_name|
  reloadable_path = RAILS_ROOT + "/vendor/plugins/#{plugin_name}/lib"
  Dependencies.load_once_paths.delete(reloadable_path)
end
