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

  describe "when filter region ranking by time strip" do

    it "should return ranking of regions filtered by time and paginated" do
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
  			{:_id => {:region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 330, :time => 30},
        {:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:04', '03:10:39'

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :listeners => 2, :bytes => 200, :time => 30},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:05', '17:55:42', 0, 2

  		expected_array = [
  			{:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:05', '17:55:42', 2, 2
    end

    it "should return ranking of regions filtered by time and date and paginated" do
    	expected_array = [
  			{:_id => {:region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 330, :time => 30},
        {:_id => {:region => "Cataluña", :country => "Spain"}, :listeners => 3, :bytes => 75, :time => 60},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 0, 2, '14/11/2014', '24/02/2015'

  		expected_array = [
  			{:_id => {:region => "Extremadura", :country => "Spain"}, :listeners => 2, :bytes => 200, :time => 30},
        {:_id => {:region => "New Jersey", :country => "United States"}, :listeners => 1, :bytes => 23, :time => 9},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '05:27:05', '23:59:59', 2, 2, '14/11/2014', '24/03/2015'

      expected_array = [
        {:_id => {:region => "Madrid", :country => "Spain"}, :listeners => 1, :bytes => 23, :time => 8},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '05:27:05', '23:59:59', 2, 2, '14/11/2014', '24/03/2015'

      expected_array = [
        {:_id => {:region => "New Jersey", :country => "United States"}, :listeners => 1, :bytes => 23, :time => 9},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '13:25:41', '13:25:41', 0, 5, '14/11/2014', '25/03/2015'

  		xhrRequestRegionRanking [], '13:25:41', '13:25:41', 0, 5, '11/02/2015', '25/03/2015'

  		expected_array = [
  			{:_id => {:region => "Nacional", :country => "Dominican Republic"}, :listeners => 1, :bytes => 16, :time => 23},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '03:10:40', '22:25:41', 0, 2, '14/11/2014', '24/03/2015'

      expected_array = [
        {:_id => {:region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 330, :time => 30},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 0, 2, '17/07/2014', '17/07/2014'

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '03:10:40', '23:59:59', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '03:10:40', '23:59:59', 1, -5
    end

    def xhrRequestRegionRanking(expected_array, from="00:00:00", to="23:59:59", start_index=0, count=5,
    	st_date='14/11/2014', end_date='25/03/2015')

      expected = expected_array.to_json
      xhr :get, :region_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
        :count => count, :start_hour => from, :end_hour => to, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end