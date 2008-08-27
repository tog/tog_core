require File.dirname(__FILE__) + '/../test_helper'

class PluginsTest < Test::Unit::TestCase
  context "The Tog Plugins setting system" do

    should "not overwrite existing settings by default" do
      Tog::Plugins.settings :test_plugin, 'key' => true
      Tog::Plugins.settings :test_plugin, 'key' => false
      assert Tog::Plugins.settings :test_plugin, 'key'
    end

    should "overwrite an existing setting if forced to do it" do
      Tog::Plugins.settings :test_plugin, 'key' => true
      Tog::Plugins.settings :test_plugin, 'key' => false, :force => :true
      assert !Tog::Plugins.settings :test_plugin, 'key'
    end

  end

end