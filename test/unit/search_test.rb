require File.dirname(__FILE__) + '/../test_helper'

class ModelType1;end;
class SearchTest < Test::Unit::TestCase
  context "The Tog search" do

    context "given a search source" do
      setup do
        @model_type_1 = ModelType1.new
        ModelType1.stubs(:site_search).with("term", {}).returns(@model_type_1)
        Tog::Search.sources << ModelType1
      end

      should "manage the source list correctly" do
        assert_contains Tog::Search.sources, ModelType1
      end

      context "and a term to search" do
        setup do
          @matches = Tog::Search.search("term")
        end
        should "retrieve the correct matches" do
          assert 1, @matches.size
          assert_equal @model_type_1, @matches.first
        end
        context "the returned collection" do
          should "be paginated" do
            assert @matches.respond_to?(:paginate)
          end
          should "have a per_page size based on Tog::Config" do
            assert Tog::Config['plugins.tog_core.pagination_size'], @matches.per_page
          end
        end
      end
      
      context "and a term to search with special pagination options" do
        setup do
          @matches = Tog::Search.search("term", {}, :per_page => 2)
        end
        context "the returned collection" do
          should "have a per_page size based on Tog::Config" do
            assert 2, @matches.per_page
          end
        end
      end
      
    end

  end
end