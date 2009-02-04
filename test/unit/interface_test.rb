require File.dirname(__FILE__) + '/../test_helper'

class ConfigTest < Test::Unit::TestCase
  context "The Tog::Interface system" do
    setup do
      @admin = Tog::Interface.sections(:admin)
    end
    context "when i18n the interface sections" do
      
      should "allow Strings as tabs/items translation keys" do
        @admin.add "Test Key With Spaces", "/admin/test"
        @admin.add "RegularString", "/admin/test"
        key_names = @admin.tabs.map(&:key)
        assert_contains key_names, "interface.admin.test_key_with_spaces"
        assert_contains key_names, "interface.admin.regularstring"
      end
      
      should "allow Symbols as tabs/items translation keys" do
        @admin.add :test_symbol_tab, "/admin/test"
        key_names = @admin.tabs.map(&:key)
        assert_contains key_names, "interface.admin.test_symbol_tab"
      end
      should "return the correct tab object for a given key" do
        #admin = Tog::Interface.sections(:admin)
        tab = @admin.add :test_tab, "/test_tab"
        assert_equal tab, @admin.tabs(:test_tab)
      end
      
    end
    
    
  end

end