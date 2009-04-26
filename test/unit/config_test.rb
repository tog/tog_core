require File.dirname(__FILE__) + '/../test_helper'

class ConfigTest < Test::Unit::TestCase
  context "The Tog config system" do

    should "be clear after a purge" do
      Tog::Config.purge
      assert_equal 0, Tog::Config.count
    end

    should "return nil for non existing keys" do
      assert_nil Tog::Config["non_existing"]
    end

    should "manage regular values" do
      Tog::Config["key"] = "value"
      assert_equal Tog::Config["key"], "value"
    end

    should "manage numbers" do
      Tog::Config["key"] = 35
      assert_equal Tog::Config["key"], "35"
      Tog::Config["key"] = 35.35
      assert_equal Tog::Config["key"], "35.35"
    end
    should "manage booleans" do
      ["false", "False", "  False", "False  ", "   False  ", false].each{|k|
        Tog::Config["key"] = k
        assert(!Tog::Config["key"])
      }
      ["true", "True", "  True", "True  ", "  True  ", true].each{|k|
        Tog::Config["key"] = k
        assert(Tog::Config["key"])
      }
    end
    
    context "when setting a value for a new key" do
      setup do
        @prev = Tog::Config.count
        Tog::Config["newkey"] = "value"
      end
      should "add a pair key-value" do
        assert @prev + 1, Tog::Config.count
      end 
      
      context "if the key exists" do
        setup do 
          # set again the same key and check the 
          # total number of setting don't increase
          @prev = Tog::Config.count
          Tog::Config["newkey"] = "new_value"
        end
        should "not add a pair key-value" do
          assert @prev, Tog::Config.count
        end      
      end
      
    end
    
    context "while managing initializations" do
      setup do
        Tog::Config["key"] = "value"
      end
      
      context "setting a new value for existing key" do
        setup do 
          Tog::Config.init_with("key", "new_value")
        end
        should_not_change 'Tog::Config["key"]'
      end
      
    end

  end

end