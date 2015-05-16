require 'rails_helper'
require 'json'

RSpec.describe RankingController, type: :controller do

	before(:each) do
      3.times do
        FactoryGirl.create(:connection_from_Galicia)
      end
      FactoryGirl.create(:connection_from_Madrid)

      2.times do
        FactoryGirl.create(:connection_from_Extremadura)
      end

      3.times do
        FactoryGirl.create(:connection_from_Cataluña)
      end

      FactoryGirl.create(:connection_from_New_Jersey)

      FactoryGirl.create(:connection_from_Nacional)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
  end

  describe "when access to ranking of regions" do
  	it "should return all ranking without pagination" do
  		expected_array = [
  			{:_id => {:region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 330, :time => 30},
        {:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
  			{:_id => {:region => "Extremadura", :country => "Spain"}, :listeners => 2, :bytes => 200, :time => 30},
        {:_id => {:region => "New Jersey", :country => "United States"}, :listeners => 1, :bytes => 23, :time => 9},
        {:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :listeners => 1, :bytes => 16, :time => 23}
  		]
  		expected = expected_array.to_json
    	xhr :get, :region_ranking, :start_date => '17/07/2014', :end_date => '25/02/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of regions paginated" do

      expected_array = [
        {:_id => {:region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 330, :time => 30},
        {:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :listeners => 2, :bytes => 200, :time => 30},
        {:_id => {:region => "New Jersey", :country => "United States"}, :listeners => 1, :bytes => 23, :time => 9},
        {:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8}
        {:hasMore => true}
      ]
      xhrRequestRegionRanking expected_array

      expected_array = [
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :listeners => 1, :bytes => 16, :time => 23}
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '17/07/2014', '25/02/2015', 5, 5

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :listeners => 2, :bytes => 200, :time => 30},
        {:_id => {:region => "New Jersey", :country => "United States"}, :listeners => 1, :bytes => 23, :time => 9},
        {:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :listeners => 1, :bytes => 16, :time => 23},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '01/12/2014', '25/02/2015', 0, 5

  		xhrRequestRegionRanking [], '01/12/2014', '25/02/2015', 5, 5
  	end

  	it "should return ranking of regions paginated and filtered by date" do

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
  			{:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '01/02/2015', '25/02/2015', 0, 2

  		expected_array = [
  			{:_id => {:region => "Nacional", :country => "Dominican Republic"}, :listeners => 1, :bytes => 16, :time => 23},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '01/02/2015', '25/03/2015', 2, 2

  		xhrRequestRegionRanking [], '14/11/2014', '25/03/2015', 6, 5

  		xhrRequestRegionRanking [], '14/11/2014', '25/03/2015', 7, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', 1, -5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', 1, 0
  	end

  end

  def xhrRequestRegionRanking(expected_array, st_date='17/07/2014', end_date='25/02/2015', start_index=0, count=5)
  	expected = expected_array.to_json
    xhr :get, :region_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end