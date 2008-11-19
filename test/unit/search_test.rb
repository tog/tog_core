require File.dirname(__FILE__) + '/../test_helper'

class ModelType1;end;
class ModelType2;end;

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
        should "retrieve matches" do
          assert 1, Tog::Search.search("term").size
          assert_equal @model_type_1, Tog::Search.search("term").first
        end
        should "return a paginated collection" do
          assert Tog::Search.search("term").respond_to?(:paginate)
        end
      end
    end

    context "with a not search enabled models" do
      setup do
        Tog::Search.sources << Tog::Config
      end
    end

  end
end