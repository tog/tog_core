require File.dirname(__FILE__) + '/../../test_helper'

class InterfaceHelperTest <  ActionView::TestCase  
  include CoreHelper
  context "The Interface helper" do
    setup do
      self.stubs(:request).returns(ActionController::TestRequest.new)
      @admin = Tog::Interface.sections(:admin)
      I18n.backend.store_translations :'en', {
         :interface => {
           :admin =>{
             :test_interface_helper => 'test_interface_helper',
             :test_sub_nav => "test_sub_nav",
             :test_sub_nav_items => {:sub_1 => "Hey", :sub_2 => "Ho", :sub_3 => "Lets go!"}
           }
         }
       }
    end

    context "for a given tab" do
      setup do
        @tab = @admin.add :test_sub_nav, "/test_sub_nav"
      end
      
      should "render the tab name with i18n strings" do
        assert_equal %(<li><a href="/test_sub_nav">test_sub_nav</a></li>), nav_link_to(@tab)
      end
      
      context "that is selected" do
        setup do
          request.request_uri = "/test_sub_nav"
        end
        should "render a class='on' attrib." do
          assert_equal %(<li class="on"><a href="/test_sub_nav">test_sub_nav</a></li>), nav_link_to(@tab)
        end
        should "render the existing sub nav items " do
          @tab.add_item "Sub 1", "/sub/1"
          @tab.add_item :sub_2,  "/sub/2"
          @tab.add_item :sub_3,  "/sub/3"
          assert_equal %(<li class="on"><a href="/test_sub_nav">test_sub_nav</a><ul><li><a href="/sub/1">Hey</a></li><li><a href="/sub/2">Ho</a></li><li><a href="/sub/3">Lets go!</a></li></ul></li>), nav_link_to(@tab)
        end
      end
      
    end
    
  end

end