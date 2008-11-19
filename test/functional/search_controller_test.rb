require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

class SearchControllerTest < Test::Unit::TestCase

  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "The Tog search controller" do

    setup do
      get :search, :term => "test"
    end
    should_assign_to :matches
    should_respond_with :success
    should_render_template :search

    should_route :get, "/search", :controller => :search, :action => :search
    should_route :post, "/search", :controller => :search, :action => :search
  end


end