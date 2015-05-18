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
  			{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
        {:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
        {:_id => "iTunes/9.1.1", :listeners => 1, :bytes => 40, :time => 20},
        {:hasMore => true}
  		]
			xhrRequestUserAgentRanking expected_array

			expected_array = [
				{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "Mozilla Firefox", :listeners => 1, :bytes => 10, :time => 5},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42'

			expected_array = [
				{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
				{:hasMore => true}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42', 0, 2

			expected_array = [
				{:_id => "Mozilla Firefox", :listeners => 1, :bytes => 10, :time => 5},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:05', '10:55:42', 2, 2
		end

		it "should return ranking of user agents filtered by time and date and paginated" do
			expected_array = [
				{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
				{:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
				{:hasMore => true}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:04', '23:59:59', 0, 2, '11/02/2015', '27/11/2015'

			expected_array = [
				{:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
				{:hasMore => false}
			]
			xhrRequestUserAgentRanking expected_array, '05:27:04', '23:59:59', 2, 2, '11/02/2015', '27/11/2015'

			expected_array = [
				{:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "iTunes/9.1.1", :listeners => 1, :bytes => 40, :time => 20},
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