require File.dirname(__FILE__) + '/../test_helper'

class PluginsTest < Test::Unit::TestCase
  context "The Tog Plugins setting system" do

    setup do
      Tog::Plugins.settings :test_plugin, :key => true
    end

    should "overwrite existing settings by default" do
      Tog::Plugins.settings :test_plugin, :key => false
      assert !Tog::Plugins.settings(:test_plugin, :key)
    end

    should "should not overwrite an existing setting if force is disabled" do
      Tog::Plugins.settings :test_plugin, {:key => false}, {:force => false}
      assert Tog::Plugins.settings(:test_plugin, :key)
    end

  end

end