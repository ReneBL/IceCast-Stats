require 'rails_helper'
require 'json'

RSpec.describe RankingController, type: :controller do
	
  before(:each) do
    2.times do
      FactoryGirl.create(:connection_from_Spain)
      FactoryGirl.create(:connection_from_Italy)
    end

    3.times do
      FactoryGirl.create(:connection_from_France)
    end

    FactoryGirl.create(:connection_from_China)
    FactoryGirl.create(:connection_from_Germany)
    FactoryGirl.create(:connection_from_United_States)

    admin = FactoryGirl.create(:admin)
    log_in(admin)
  end

  describe "when filter country ranking by time strip" do

    it "should return ranking of countries filtered by time and paginated" do
    	expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Spain", :listeners => 2, :bytes => 22712, :time => 6},
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array

  		expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '05:27:05', '10:55:42'

  		expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array, '05:27:05', '10:55:42', 0, 2

  		expected_array = [
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '05:27:05', '10:55:42', 2, 2
    end

    it "should return ranking of countries filtered by time and date and paginated" do
    	expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array, '05:27:05', '23:59:59', 0, 2, '14/11/2014', '24/03/2015'

  		expected_array = [
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '05:27:05', '23:59:59', 2, 2, '14/11/2014', '24/03/2015'

      expected_array = [
        {:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
        {:_id => "China", :listeners => 1, :bytes => 23978, :time => 6},
        {:hasMore => false}
      ]
      xhrRequestCountryRanking expected_array, '09:40:02', '23:59:59', 0, 5, '14/11/2014', '25/03/2015'

  		expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Spain", :listeners => 2, :bytes => 22712, :time => 6},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array, '03:10:40', '23:59:59', 0, 2, '14/11/2014', '24/03/2015'

  		expected_array = [
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '03:10:40', '23:59:59', 2, 2, '14/11/2014', '24/03/2015'

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '03:10:40', '23:59:59', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '03:10:40', '23:59:59', 1, -5
    end

    def xhrRequestCountryRanking(expected_array, from="00:00:00", to="23:59:59", start_index=0, count=5,
    	st_date='14/11/2014', end_date='25/03/2015')

      expected = expected_array.to_json
      xhr :get, :country_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
        :count => count, :start_hour => from, :end_hour => to, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end