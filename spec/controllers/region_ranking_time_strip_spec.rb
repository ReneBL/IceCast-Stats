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
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Galicia", :country => "Spain"}, :time => 30, :bytes => 330, :listeners => 3},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :time => 30, :bytes => 200, :listeners => 2},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :time => 23, :bytes => 16, :listeners => 1},
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array

  		expected_array = [
        {:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Galicia", :country => "Spain"}, :time => 30, :bytes => 330, :listeners => 3},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:04', '03:10:39'

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :time => 30, :bytes => 200, :listeners => 2},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:05', '17:55:42', 0, 2

  		expected_array = [
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
  			{:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:05', '17:55:42', 2, 2
    end

    it "should return ranking of regions filtered by time and date and paginated" do
    	expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Galicia", :country => "Spain"}, :time => 30, :bytes => 330, :listeners => 3},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 0, 2, '17/07/2014', '24/02/2015'

  		expected_array = [
  			{:_id => {:region => "Extremadura", :country => "Spain"}, :time => 30, :bytes => 200, :listeners => 2},
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:hasMore => true}
  		]
  		xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 2, 2, '17/07/2014', '24/02/2015'

      expected_array = [
        {:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 4, 2, '17/07/2014', '24/02/2015'

      expected_array = [
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '13:25:41', '13:25:41', 0, 5, '14/11/2014', '25/03/2015'

  		xhrRequestRegionRanking [], '13:25:41', '13:25:41', 0, 5, '11/02/2015', '25/03/2015'

  		expected_array = [
  			{:_id => {:region => "Nacional", :country => "Dominican Republic"}, :time => 23, :bytes => 16, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '17:55:43', '22:25:41', 0, 2, '17/07/2014', '25/02/2015'

      expected_array = [
        {:_id => {:region => "Galicia", :country => "Spain"}, :time => 30, :bytes => 330, :listeners => 3},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '00:27:04', '22:25:41', 0, 2, '17/07/2014', '17/07/2014'

      xhrRequestRegionRanking [], '00:00:00', '00:27:03', 0, 5, '17/07/2013', '17/07/2014'

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '03:10:40', '23:59:59', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '03:10:40', '23:59:59', 1, -5
    end

    def xhrRequestRegionRanking(expected_array, from="00:00:00", to="23:59:59", start_index=0, count=5,
    	st_date='17/07/2014', end_date='25/02/2015')

      expected = expected_array.to_json
      xhr :get, :region_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
        :count => count, :start_hour => from, :end_hour => to, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end