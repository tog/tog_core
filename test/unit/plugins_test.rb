require File.dirname(__FILE__) + '/../test_helper'

class PluginsTest < Test::Unit::TestCase
  context "The Tog Plugins setting system" do

    setup do
      Tog::Plugins.settings :test_plugin, :key => true
    end

    should "should not overwrite existing settings by default" do
      Tog::Plugins.settings :test_plugin, :key => false
      assert Tog::Plugins.settings(:test_plugin, :key)
    end

    should "should overwrite an existing setting if forced" do
      Tog::Plugins.settings :test_plugin, {:key => false}, {:force => true}
      assert !Tog::Plugins.settings(:test_plugin, :key)
    end

  end

end