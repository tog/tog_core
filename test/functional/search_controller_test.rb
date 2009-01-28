require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

class SearchControllerTest < ActionController::TestCase

  context "The Tog search controller" do

    setup do
      @term = "term"
      @match = returning mock do |m|
        m.stubs(:title).returns("title")
      end
      # Trigger pagination using a collection bigger than per_page option
      @matches = [@match,@match].paginate :per_page => 1 
      Tog::Search.stubs(:search).with(@term, {}, {:page => '1'}).returns(@matches)
      get :search, :global_search_field => @term
    end

    should_paginate_collection :matches
    should_display_pagination

    should_respond_with :success
    should_render_template :search

    should_route :get, "/search", :controller => :search, :action => :search
    should_route :post, "/search", :controller => :search, :action => :search

  end


end