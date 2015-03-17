require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do
  describe "when access to controllers index" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_on_2013)
      end
    
      FactoryGirl.create(:connection_on_2014)
    
      3.times do
        FactoryGirl.create(:connection_on_2015)
      end
    
      year_connections_array = [
        { :_id => { :year => 2015 }, :count => 3 },
        { :_id => { :year => 2014 }, :count => 1 },
        { :_id => { :year => 2013 }, :count => 2 }
      ]
      @year_connections = year_connections_array.to_json
    end
    it "should response" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  
    it "should response year connections in JSON" do
      xhr :get, :index, :format => :json
      expect(response.body).to eql(@year_connections)
    end
  end
  
  describe "when access to controllers months" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_on_Jan_2014)
      end
      
      FactoryGirl.create(:connection_on_Feb_2014)
      FactoryGirl.create(:connection_on_Mar_2014)
      FactoryGirl.create(:connection_on_2015)
      
      month_connections_per_year_array = [
        { :_id => { :month => 1 }, :count => 2 },
        { :_id => { :month => 2 }, :count => 1 },
        { :_id => { :month => 3 }, :count => 1 }
      ]
      @month_connections_per_year = month_connections_per_year_array.to_json
    end
    
    it "should response month connections per 2014 year in JSON" do
      xhr :get, :months, :year => 2014, :format => :json
      expect(response.body).to eql(@month_connections_per_year)
    end
  end
  
  describe "when access to controllers years" do
    before(:each) do
      
      FactoryGirl.create(:connection_on_2015)
      FactoryGirl.create(:connection_on_2014)
      FactoryGirl.create(:connection_on_2013)
      
      years_array = [
        { :_id => { :year => 2015 }},
        { :_id => { :year => 2014 }},
        { :_id => { :year => 2013 }}
      ]
      @years = years_array.to_json
    end
    
    it "should response years in JSON" do
      xhr :get, :years, :format => :json
      expect(response.body).to eql(@years)
    end
  end
  
  describe "when access to ranges" do
    before(:each) do
      FactoryGirl.create(:connection_with_5_seconds)
      FactoryGirl.create(:connection_with_20_seconds)
      
      FactoryGirl.create(:connection_with_30_seconds)
      FactoryGirl.create(:connection_with_60_seconds)
      
      FactoryGirl.create(:connection_with_120_seconds)     
      
      ranges_array = [
        { :_id => "range 0-20", :count => 2},
        { :_id => "range 20-60", :count => 2},
        { :_id => "range > 60", :count => 1}
      ]
      @ranges = ranges_array.to_json
    end
    
    it "should return ranges of seconds" do
      xhr :get, :ranges, :format => :json
      expect(response.body).to eql(@ranges)
    end
    
  end
  
end
