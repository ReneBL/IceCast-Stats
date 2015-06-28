=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

require 'rails_helper'
require 'json'

RSpec.describe RankingController, type: :controller do

	before(:each) do
      3.times do
        FactoryGirl.create(:connection_from_Coruna)
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
  			{:_id => {:city => "A Coruna", :region => "Galicia", :country => "Spain"}, :time => 60, :bytes => 120, :listeners => 3},
        {:_id => {:city => "Bilbao", :region => "Pais Vasco", :country => "Spain"}, :time => 45, :bytes => 90, :listeners => 3},
  			{:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :time => 20, :bytes => 40, :listeners => 2},
        {:_id => {:city => "Barcelona", :region => "Cataluna", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1}
  		]
  		expected = expected_array.to_json
    	xhr :get, :city_ranking, :start_date => '14/11/2014', :end_date => '11/02/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of cities paginated" do

      expected_array = [
        {:_id => {:city => "A Coruna", :region => "Galicia", :country => "Spain"}, :time => 60, :bytes => 120, :listeners => 3},
        {:_id => {:city => "Bilbao", :region => "Pais Vasco", :country => "Spain"}, :time => 45, :bytes => 90, :listeners => 3},
        {:hasMore => true}
      ]
      xhrRequestCityRanking expected_array, '14/11/2014', '11/02/2015', 0, 2

      expected_array = [
        {:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :time => 20, :bytes => 40, :listeners => 2},
        {:_id => {:city => "Barcelona", :region => "Cataluna", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestCityRanking expected_array, '17/07/2014', '25/02/2015', 2, 2

  		expected_array = [
        {:_id => {:city => "Bilbao", :region => "Pais Vasco", :country => "Spain"}, :time => 45, :bytes => 90, :listeners => 3},
        {:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :time => 20, :bytes => 40, :listeners => 2},
        {:hasMore => false}
  		]
  		xhrRequestCityRanking expected_array, '02/12/2014', '11/02/2015', 0, 2

  		xhrRequestCityRanking [], '02/12/2014', '11/02/2015', 3, 5
  	end

  	it "should return ranking of cities paginated and filtered by date" do

      expected_array = [
        {:_id => {:city => "Unknown", :region => "Unknown", :country => "Unknown"}, :time => 16, :bytes => 11356, :listeners => 1},
        {:_id => {:city => "BlaBla", :region => "Unknown", :country => "Unknown"}, :time => 8, :bytes => 657, :listeners => 1},
        {:hasMore => true}
      ]
      xhrRequestCityRanking expected_array, '26/11/2015', '28/11/2015', 0, 2

      expected_array = [
        {:_id => {:city => "Unknown", :region => "Unknown", :country => "Spain"}, :time => 6, :bytes => 345, :listeners => 1},
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