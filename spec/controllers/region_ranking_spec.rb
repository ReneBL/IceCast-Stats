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
      FactoryGirl.create(:connection_from_Unknown_Region)
      FactoryGirl.create(:connection_from_Unknown_Country)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
  end

  describe "when access to ranking of regions" do
  	it "should return all ranking without pagination" do
  		expected_array = [
        {:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Galicia", :country => "Spain"}, :time => 30, :bytes => 330, :listeners => 3},
  			{:_id => {:region => "Extremadura", :country => "Spain"}, :time => 30, :bytes => 200, :listeners => 2},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :time => 23, :bytes => 16, :listeners => 1},
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1}
  		]
  		expected = expected_array.to_json
    	xhr :get, :region_ranking, :start_date => '17/07/2014', :end_date => '25/02/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of regions paginated" do

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
        {:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '17/07/2014', '25/02/2015', 5, 5

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Extremadura", :country => "Spain"}, :time => 30, :bytes => 200, :listeners => 2},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :time => 23, :bytes => 16, :listeners => 1},
        {:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '01/12/2014', '25/02/2015', 0, 5

  		xhrRequestRegionRanking [], '01/12/2014', '25/02/2015', 5, 5
  	end

  	it "should return ranking of regions paginated and filtered by date" do

  		expected_array = [
  			{:_id => {:region => "Cataluña", :country => "Spain"}, :time => 60, :bytes => 75, :listeners => 3},
        {:_id => {:region => "Nacional", :country => "Dominican Republic"}, :time => 23, :bytes => 16, :listeners => 1},
        {:hasMore => true}
      ]
      xhrRequestRegionRanking expected_array, '01/02/2015', '25/02/2015', 0, 2

      expected_array = [
  			{:_id => {:region => "New Jersey", :country => "United States"}, :time => 9, :bytes => 23, :listeners => 1},
        {:_id => {:region => "Madrid", :country => "Spain"}, :time => 8, :bytes => 23, :listeners => 1},
        {:hasMore => false}
  		]
  		xhrRequestRegionRanking expected_array, '01/02/2015', '25/03/2015', 2, 2

      expected_array = [
        {:_id => {:region => "BlaBla", :country => "Unknown"}, :time => 25, :bytes => 80, :listeners => 1},
        {:_id => {:region => "Unknown", :country => "Spain"}, :time => 14, :bytes => 40, :listeners => 1},
        {:hasMore => false}
      ]
      xhrRequestRegionRanking expected_array, '17/07/2015', '18/07/2015', 0, 2

  		xhrRequestRegionRanking [], '14/11/2014', '25/03/2015', 6, 5

  		xhrRequestRegionRanking [], '14/11/2014', '25/03/2015', 7, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', 1, -5

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', 1, 0

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', 1, nil

      error = {"error" => "Not valid indexes"}
      xhrRequestRegionRanking error, '14/11/2014', '25/03/2015', nil, 1
  	end

  end

  def xhrRequestRegionRanking(expected_array, st_date='17/07/2014', end_date='25/02/2015', start_index=0, count=5)
  	expected = expected_array.to_json
    xhr :get, :region_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end