require File.dirname(__FILE__) + '/../test_helper'

class SearchTest < Test::Unit::TestCase
  context "The Tog search" do

    context "with a few search enabled models" do
      setup do
        Tog::Search.sources << User
      end
      should "find matching results" do
        # => todo implement this !
        #query = "ipod"
        #assert_equal 1, Tog::Search.search(query).size, "Should find one match for '#{query}'"
      end
    end

    context "with a not search enabled models" do
      setup do
        Tog::Search.sources << Tog::Config
      end
      should "silently skip these models" do
        assert_equal 0, Tog::Search.search("ipod").size
      end
    end
  end
end