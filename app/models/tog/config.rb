module Tog

  # The Tog::Config object emulates a hash with simple bracket methods
  # which allow you to get and set values in the configuration table:
  #
  #   Tog::Config['setting.name'] = 'value'
  #   Tog::Config['setting.name'] #=> "value"
  class Config < ActiveRecord::Base
    set_table_name "config"


    class << self

      def [](key)
        pair = find_by_key(key) if table_exists?
        pair.value unless pair.nil?
      end

      def []=(key, value)
        if table_exists?
          pair = find_by_key(key)
          unless pair
            pair = new
            pair.key, pair.value = key, value
            pair.save
          else
            pair.value = value
            pair.save
          end
        end
        value
      end

      def to_hash
        Hash[ *find(:all).map { |pair| [pair.key, pair.value] }.flatten ]
      end

      def list(regex=//)
        regex = /#{regex}/ if regex.class == String
        settings = self.to_hash.delete_if{|k,v| ! (k =~ regex)}

        key_width   = settings.keys.collect  {|k| k.length}.max
        value_width = settings.values.collect{|v| v.to_s.length}.max
        settings.each_pair do |k,v|
          puts "     #{k.rjust(key_width)} ===========> #{v.to_s.ljust(value_width)}     "
        end
      end

      def init_with(key, value)
        if table_exists?
          pair = find_by_key(key)
        end
        self[key] = value if pair.nil?
      end

      def purge
        destroy_all
      end

      private
      def table_exists?
        existence = ActiveRecord::Base.connection.tables.include?(self.table_name)
        unless existence
          logger.warn "Table 'config' not exists. Just the last effort to create the config table if doesn't exists"
          begin
            create_tog_config_table
            existence = true
          rescue Exception => e
            logger.warn "Unable to create table 'config'. Holy shit!"
            logger.error e
          end
        end
        existence
      end
      # Just the last effort to create the config table if doesn't exists
      def create_tog_config_table
        ActiveRecord::Base.connection.create_table "config", :force => false do |t|
          t.string :key,   :limit => 255, :default => "", :null => false
          t.string :value
          t.timestamps
        end
        ActiveRecord::Base.connection.add_index "config", ["key"], :name => "key", :unique => true
      end

    end

    def value=(param)
      write_attribute :value, param.nil? ? param : param.to_s
    end

    def value
      attrb = read_attribute(:value).downcase.strip rescue read_attribute(:value)
      (attrb == "true" || attrb == "false") ?  attrb == "true" : read_attribute(:value)
    end

  end
end
