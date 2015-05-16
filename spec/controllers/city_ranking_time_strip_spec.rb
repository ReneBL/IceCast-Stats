require 'rails_helper'
require 'json'

RSpec.describe RankingController, type: :controller do
	
  before(:each) do
      3.times do
        FactoryGirl.create(:connection_from_Coruña)
      end
      FactoryGirl.create(:connection_from_Barcelona)

      2.times do
        FactoryGirl.create(:connection_from_Valencia)
      end

      3.times do
        FactoryGirl.create(:connection_from_Bilbao)
      end

      FactoryGirl.create(:connection_from_Unknown_all)
      FactoryGirl.create(:connection_from_Unknown_city_region)
      FactoryGirl.create(:connection_from_Unknown_country_region)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
  end

  describe "when filter city ranking by time strip" do

    it "should return ranking of cities filtered by time and paginated" do
    	expected_array = [
        {:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 120, :time => 60},
        {:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :listeners => 3, :bytes => 90, :time => 45},
        {:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :listeners => 2, :bytes => 40, :time => 20},
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array

  		expected_array = [
  			{:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 120, :time => 60},
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array, '05:27:04', '10:55:41'

  		expected_array = [
        {:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 120, :time => 60},
  			{:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :listeners => 3, :bytes => 90, :time => 45},
        {:hasMore => true}
  		]
  		xhrRequestCityRanking expected_array, '03:10:39', '10:55:42', 0, 2

  		expected_array = [
  			{:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :listeners => 2, :bytes => 40, :time => 20},
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array, '03:10:39', '10:55:42', 2, 2
    end

    it "should return ranking of cities filtered by time and date and paginated" do
    	expected_array = [
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array, '05:27:05', '23:59:59', 0, 2, '14/11/2014', '10/02/2015'

  		expected_array = [
  			{:_id => {:city => "Unknown", :region => "Unknown", :country => "Unknown"}, :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => {:city => "BlaBla", :region => "Unknown", :country => "Unknown"}, :listeners => 1, :bytes => 657, :time => 8},
        {:hasMore => true}
  		]
  		xhrRequestCityRanking expected_array, '05:27:04', '23:59:59', 0, 2, '26/11/2015', '28/11/2015'

      expected_array = [
        {:_id => {:city => "Unknown", :region => "Unknown", :country => "Spain"}, :listeners => 1, :bytes => 345, :time => 6},
        {:hasMore => false}
      ]
      xhrRequestCityRanking expected_array, '05:27:04', '23:59:59', 2, 2, '26/11/2015', '28/11/2015'

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '03:10:40', '23:59:59', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '03:10:40', '23:59:59', 1, -5
    end

    def xhrRequestCityRanking(expected_array, from="00:00:00", to="23:59:59", start_index=0, count=4,
    	st_date='14/11/2014', end_date='11/02/2015')

      expected = expected_array.to_json
      xhr :get, :city_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
        :count => count, :start_hour => from, :end_hour => to, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end