require File.dirname(__FILE__) + '/../test_helper'

class ModelType1;end;
class ModelType2;end;
class SearchTest < Test::Unit::TestCase
  context "The Tog search" do

    context "given multiple search sources and a term" do
      setup do
        @model1 = ModelType1.new
        @model2 = ModelType2.new
        @term = "term"
        ModelType1.stubs(:site_search).with(@term, any_parameters).returns(@model1)
        ModelType2.stubs(:site_search).with(@term, any_parameters).returns(@model2)
        Tog::Search.sources << "ModelType1"
        Tog::Search.sources << "ModelType2"
      end

      should "manage the source list correctly" do
        assert_contains Tog::Search.sources, "ModelType1"
      end
      
      context "when searching" do
        setup do
          @matches = Tog::Search.search(@term)
        end

        should "retrieve the correct number of matches" do
          assert 2, @matches.size
        end
        
        should "retrieve instances of the multiple sources" do
          assert_contains(@matches, @model1)
          assert_contains(@matches, @model2)
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
      
      context "when searching with special pagination options" do
        setup do
          @matches = Tog::Search.search(@term, {}, :per_page => 2)
        end
        context "the returned collection" do
          should "have a per_page size based on Tog::Config" do
            assert 2, @matches.per_page
          end
        end
      end

      context "when searching with :only & :expect options" do
        setup do
          @m1 = Tog::Search.search(@term, :only => "ModelType2")
          @m2 = Tog::Search.search(@term, :except => "ModelType1")
        end

        should "retrieve the correct number of matches" do
          [@m1, @m2].each{|m|
            assert_equal 1, m.size
          }
        end
        should "retrieve only instances of the selected sources" do
          [@m1, @m2].each{|m|
            assert_contains(m, @model2)
            assert_does_not_contain(@m, @model1)
          }
        end
      end

    end
    

  end
end