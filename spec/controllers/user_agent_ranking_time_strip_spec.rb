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
		FactoryGirl.create(:connection_with_Firefox)
		FactoryGirl.create(:connection_with_iTunes)

		2.times do
			FactoryGirl.create(:connection_with_Safari)
		end

		5.times do
			FactoryGirl.create(:connection_with_Chrome)
		end

		FactoryGirl.create(:connection_with_Winamp)
		FactoryGirl.create(:connection_with_VLC)

		admin = FactoryGirl.create(:admin)
		log_in(admin)
	end

	describe "when filter country ranking by time strip" do

		it "should return ranking of user agents filtered by time and paginated" do
			expected_array = [
  			{:_id => "Google Chrome", :time => 75, :bytes => 150, :listeners => 5},
				{:_id => "Safari", :time => 20, :bytes => 40, :listeners => 2},
				{:_id => "iTunes/9.1.1", :time => 20, :bytes => 40, :listeners => 1},
				{:_id => "Winamp", :time => 16, :bytes => 11356, :listeners => 1},
				{:_id => "VLC Media Player", :time => 6, :bytes => 345, :listeners => 1},
        {:hasMore => true}
  		]
			xhrRequestUserAgentRanking expected_array

			expected_array = [
				{:_id => "Google Chrome", :time => 75, :bytes => 150, :listeners => 5},
        {:_id => "Winamp", :time => 16, :bytes => 11356, :listeners => 1},
        {:_id => "Mozilla Firefox", :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42'

			expected_array = [
				{:_id => "Google Chrome", :time => 75, :bytes => 150, :listeners => 5},
        {:_id => "Winamp", :time => 16, :bytes => 11356, :listeners => 1},
				{:hasMore => true}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42', 0, 2

			expected_array = [
				{:_id => "Mozilla Firefox", :time => 5, :bytes => 10, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42', 2, 2
		end

		it "should return ranking of user agents filtered by time and date and paginated" do
			expected_array = [
				{:_id => "Google Chrome", :time => 75, :bytes => 150, :listeners => 5},
        {:_id => "Winamp", :time => 16, :bytes => 11356, :listeners => 1},
				{:hasMore => true}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:04', '23:59:59', 0, 2, '11/02/2015', '27/11/2015'

			expected_array = [
				{:_id => "VLC Media Player", :time => 6, :bytes => 345, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:04', '23:59:59', 2, 2, '11/02/2015', '27/11/2015'

			expected_array = [
				{:_id => "Safari", :time => 20, :bytes => 40, :listeners => 2},
				{:_id => "iTunes/9.1.1", :time => 20, :bytes => 40, :listeners => 1},
				{:_id => "Winamp", :time => 16, :bytes => 11356, :listeners => 1},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '03:10:39', '06:27:04', 0, 5, '14/11/2014', '27/11/2015'

			error = {"error" => "Not valid indexes"}
			xhrRequestUserAgentRanking error, '03:10:40', '23:59:59', -1, 5

			error = {"error" => "Not valid indexes"}
			xhrRequestUserAgentRanking error, '03:10:40', '23:59:59', 1, -5
		end

		def xhrRequestUserAgentRanking(expected_array, from="00:00:00", to="23:59:59", start_index=0, count=5,
			st_date='14/11/2014', end_date='27/11/2015')

			expected = expected_array.to_json
			xhr :get, :user_agent_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
				:count => count, :start_hour => from, :end_hour => to, :format => :json
			expect(response.body).to eql(expected)
		end
	end
end