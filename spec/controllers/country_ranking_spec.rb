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

    FactoryGirl.create(:connection_from_Unknown)

    admin = FactoryGirl.create(:admin)
    log_in(admin)
	end

  describe "when access to ranking of countries" do
  	it "should return all ranking without pagination" do
  		expected_array = [
  			{:_id => "Italy", :time => 146, :bytes => 9074, :listeners => 2},
        {:_id => "France", :time => 30, :bytes => 26298, :listeners => 3},
        {:_id => "United States", :time => 20, :bytes => 2567546, :listeners => 1},
        {:_id => "Germany", :time => 18, :bytes => 42890, :listeners => 1},
        {:_id => "China", :time => 6, :bytes => 23978, :listeners => 1},
        {:_id => "Spain", :time => 6, :bytes => 22712, :listeners => 2}
  		]
  		expected = expected_array.to_json
    	xhr :get, :country_ranking, :start_date => '14/11/2014', :end_date => '25/03/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of countries paginated" do

  		expected_array = [
  			{:_id => "Italy", :time => 146, :bytes => 9074, :listeners => 2},
        {:_id => "France", :time => 30, :bytes => 26298, :listeners => 3},
        {:_id => "United States", :time => 20, :bytes => 2567546, :listeners => 1},
  			{:_id => "Germany", :time => 18, :bytes => 42890, :listeners => 1},
        {:_id => "China", :time => 6, :bytes => 23978, :listeners => 1},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array

  		expected_array = [
        {:_id => "France", :time => 30, :bytes => 26298, :listeners => 3},
        {:_id => "United States", :time => 20, :bytes => 2567546, :listeners => 1},
  			{:_id => "Germany", :time => 18, :bytes => 42890, :listeners => 1},
        {:_id => "China", :time => 6, :bytes => 23978, :listeners => 1},
        {:_id => "Spain", :time => 6, :bytes => 22712, :listeners => 2},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '14/11/2014', '25/03/2015', 1, 6

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 6, 5
  	end

  	it "should return ranking of countries paginated and filtered by date" do
  		expected_array = [
  			{:_id => "Italy", :time => 146, :bytes => 9074, :listeners => 2},
        {:_id => "United States", :time => 20, :bytes => 2567546, :listeners => 1},
        {:_id => "Germany", :time => 18, :bytes => 42890, :listeners => 1},
        {:_id => "China", :time => 6, :bytes => 23978, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015'

  		expected_array = [
  			{:_id => "Italy", :time => 146, :bytes => 9074, :listeners => 2},
        {:_id => "United States", :time => 20, :bytes => 2567546, :listeners => 1},
        {:hasMore => true}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015', '25/03/2015', 0, 2

  		expected_array = [
  			{:_id => "Germany", :time => 18, :bytes => 42890, :listeners => 1},
        {:_id => "China", :time => 6, :bytes => 23978, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestCountryRanking expected_array, '01/02/2015', '25/03/2015', 2, 2

      expected_array = [
        {:_id => "Unknown", :time => 6, :bytes => 11356, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestCountryRanking expected_array, '26/03/2015', '26/11/2015', 0, 2

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 6, 5

  		xhrRequestCountryRanking [], '14/11/2014', '25/03/2015', 7, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', 1, -5

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', 1, 0

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', 1, nil

      error = {"error" => "Not valid indexes"}
      xhrRequestCountryRanking error, '14/11/2014', '25/03/2015', nil, 1
  	end

  end

  def xhrRequestCountryRanking(expected_array, st_date='14/11/2014', end_date='25/03/2015', start_index=0, count=5)
  	expected = expected_array.to_json
    xhr :get, :country_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end