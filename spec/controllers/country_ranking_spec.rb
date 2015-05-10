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

  describe "when access to ranking of countries" do
  	it "should return all ranking without pagination" do
  		expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Spain", :listeners => 2, :bytes => 22712, :time => 6},
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6}
  		]
  		expected = expected_array.to_json
    	xhr :get, :country_ranking, :start_date => '14/11/2014', :end_date => '25/03/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of countries paginated" do

  		expected_array = [
  			{:_id => "France", :listeners => 3, :bytes => 26298, :time => 30},
  			{:_id => "Spain", :listeners => 2, :bytes => 22712, :time => 6},
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18}
  		]
  		xhrRequestCountryRanking expected_array

  		expected_array = [
  			{:_id => "Spain", :listeners => 2, :bytes => 22712, :time => 6},
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6}
  		]
  		xhrRequestCountryRanking expected_array, '14/11/2014', '25/03/2015', 1, 6

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 6, 5
  	end

  	it "should return ranking of countries paginated and filtered by date" do
  		expected_array = [
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20},
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015'

  		expected_array = [
  			{:_id => "Italy", :listeners => 2, :bytes => 9074, :time => 146},
  			{:_id => "United States", :listeners => 1, :bytes => 2567546, :time => 20}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015', '25/03/2015', 0, 2

  		expected_array = [
  			{:_id => "Germany", :listeners => 1, :bytes => 42890, :time => 18},
  			{:_id => "China", :listeners => 1, :bytes => 23978, :time => 6}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015', '25/03/2015', 2, 2

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 6, 5

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 7, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', 1, -5
  	end

  end

  def xhrRequestCountryRanking(expected_array, st_date='14/11/2014', end_date='25/03/2015', start_index=0, count=5)
  	expected = expected_array.to_json
    xhr :get, :country_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end