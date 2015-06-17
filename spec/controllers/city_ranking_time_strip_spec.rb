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
				{:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :time => 60, :bytes => 120, :listeners => 3},
				{:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :time => 45,  :bytes => 90, :listeners => 3},
				{:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :time => 20, :bytes => 40, :listeners => 2},
				{:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestCityRanking expected_array

			expected_array = [
				{:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :time => 60, :bytes => 120, :listeners => 3},
				{:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestCityRanking expected_array, '05:27:04', '10:55:41'

			expected_array = [
				{:_id => {:city => "A Coruña", :region => "Galicia", :country => "Spain"}, :time => 60, :bytes => 120, :listeners => 3},
				{:_id => {:city => "Bilbao", :region => "País Vasco", :country => "Spain"}, :time => 45,  :bytes => 90, :listeners => 3},
				{:hasMore => true}
			]
			xhrRequestCityRanking expected_array, '03:10:39', '10:55:42', 0, 2

			expected_array = [
				{:_id => {:city => "Valencia", :region => "Comunidad Valenciana", :country => "Spain"}, :time => 20, :bytes => 40, :listeners => 2},
				{:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestCityRanking expected_array, '03:10:39', '10:55:42', 2, 2
		end

		it "should return ranking of cities filtered by time and date and paginated" do
			expected_array = [
				{:_id => {:city => "Barcelona", :region => "Cataluña", :country => "Spain"}, :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestCityRanking expected_array, '05:27:05', '23:59:59', 0, 2, '14/11/2014', '10/02/2015'

			expected_array = [
				{:_id => {:city => "Unknown", :region => "Unknown", :country => "Unknown"}, :time => 16, :bytes => 11356, :listeners => 1},
				{:_id => {:city => "BlaBla", :region => "Unknown", :country => "Unknown"}, :time => 8, :bytes => 657, :listeners => 1},
				{:hasMore => true}
			]
			xhrRequestCityRanking expected_array, '05:27:04', '23:59:59', 0, 2, '26/11/2015', '28/11/2015'

			expected_array = [
				{:_id => {:city => "Unknown", :region => "Unknown", :country => "Spain"}, :time => 6, :bytes => 345, :listeners => 1},
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