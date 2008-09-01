require File.dirname(__FILE__) + '/../test_helper'

class ObserverTest < Test::Unit::TestCase
  context "The Tog Plugins system" do

    should "be able to add observers to rails start-up via Desert" do
      Tog::Plugins.observers << :test_observer
      assert_contains Desert::Rails::Observer.observers, :test_observer
    end


  end

end