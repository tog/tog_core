require File.dirname(__FILE__) + '/../test_helper'

class ConfigTest < Test::Unit::TestCase
  context "The Tog config system" do

    should "be clear after a purge" do
      Tog::Config.purge
      assert_equal 0, Tog::Config.find(:all).size
    end

    should "return nil for non existing keys" do
      assert_nil Tog::Config["key"]
    end

    should "manage regular values" do
      Tog::Config["key"] = "value"
      assert_equal(Tog::Config["key"], "value")
    end

    should "manage numbers" do
      Tog::Config["key"] = 35
      assert_equal(Tog::Config["key"], "35")
      Tog::Config["key"] = 35.35
      assert_equal(Tog::Config["key"], "35.35")
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
    should "create new setting if the key don't exist" do
      assert_difference(Tog::Config, :count) do
        Tog::Config["key"] = "value"
      end
    end
    
    should "replace setting's value if the key exist" do
      Tog::Config["key"] = "value"
      assert_no_difference(Tog::Config, :count) do
        Tog::Config["key"] = "value"
      end
    end
    
    context "while managing initializations" do
      should "create a new setting for non existing keys" do
        assert_difference(Tog::Config, :count) do
          Tog::Config.init_with("key", "value")
        end
      end
      should "not modify value for existing keys" do
        assert_difference(Tog::Config, :count) do
          Tog::Config["key"] = "X"
          assert_equal(Tog::Config["key"], "X")
          Tog::Config.init_with("key", "Y")
          assert_equal(Tog::Config["key"], "X")
          Tog::Config.init_with("key", "value")
        end
      end
    end

  end

end