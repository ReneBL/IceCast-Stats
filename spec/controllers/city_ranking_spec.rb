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

  describe "when access to ranking of cities" do
  	it "should return all ranking without pagination" do
  		expected_array = [
  			{:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 120, :time => 60},
        {:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :listeners => 3, :bytes => 90, :time => 45},
  			{:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :listeners => 2, :bytes => 40, :time => 20},
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5}
  		]
  		expected = expected_array.to_json
    	xhr :get, :city_ranking, :start_date => '14/11/2014', :end_date => '11/02/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of cities paginated" do

      expected_array = [
        {:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :listeners => 3, :bytes => 120, :time => 60},
        {:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :listeners => 3, :bytes => 90, :time => 45},
        {:hasMore => true}
      ]
      xhrRequestCityRanking expected_array, '14/11/2014', '11/02/2015', 0, 2

      expected_array = [
        {:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :listeners => 2, :bytes => 40, :time => 20},
        {:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
      ]
      xhrRequestCityRanking expected_array, '17/07/2014', '25/02/2015', 2, 2

  		expected_array = [
        {:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :listeners => 3, :bytes => 90, :time => 45},
        {:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :listeners => 2, :bytes => 40, :time => 20},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array, '02/12/2014', '11/02/2015', 0, 2

  		xhrRequestCityRanking [], '02/12/2014', '11/02/2015', 3, 5
  	end

  	it "should return ranking of cities paginated and filtered by date" do

      expected_array = [
        {:_id => {:city => "Unknown", :region => "Unknown", :country => "Unknown"}, :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => {:city => "BlaBla", :region => "Unknown", :country => "Unknown"}, :listeners => 1, :bytes => 657, :time => 8},
        {:hasMore => true}
      ]
      xhrRequestCityRanking expected_array, '26/11/2015', '28/11/2015', 0, 2

      expected_array = [
        {:_id => {:city => "Unknown", :region => "Unknown", :country => "Spain"}, :listeners => 1, :bytes => 345, :time => 6},
        {:hasMore => false}
      ]
      xhrRequestCityRanking expected_array, '26/11/2015', '28/11/2015', 2, 2

  		xhrRequestCityRanking [], '14/01/2014', '25/12/2015', 7, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '14/11/2014', '25/03/2015', 1, -5

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '14/11/2014', '25/03/2015', 1, 0

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '14/11/2014', '25/03/2015', 1, nil

      error = {"error" => "Not valid indexes"}
      xhrRequestCityRanking error, '14/11/2014', '25/03/2015', nil, 1
  	end

  end

  def xhrRequestCityRanking(expected_array, st_date='14/11/2014', end_date='11/02/2015', start_index=0, count=4)
  	expected = expected_array.to_json
    xhr :get, :city_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end