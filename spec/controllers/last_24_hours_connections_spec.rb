require 'rails_helper'
require 'json'

RSpec.describe RealTimeController, type: :controller do

	before(:each) do
		FactoryGirl.create(:connection_24_hours_1_minute_ago)
		FactoryGirl.create(:connection_24_hours_ago)
			
		FactoryGirl.create(:connection_2_hours_ago)
		FactoryGirl.create(:connection_1_second_ago)
		FactoryGirl.create(:connection_1_second_above)
			
		admin = FactoryGirl.create(:admin)
		log_in(admin)
	end
	
	describe "when access to last 24 hours connections" do
		it "should return number of connections in last 24 hours" do
			expected_array = [
				{:_id => {:datetime => DateTime.evolve((DateTime.now - 24.hours).change(sec: 0)), :listeners => 6}},
        {:_id => {:datetime => DateTime.evolve((DateTime.now - 2.hours).change(sec: 0)), :listeners => 2}},
        {:_id => {:datetime => DateTime.evolve((DateTime.now - 1.second).change(sec: 0)), :listeners => 8}}
      ]
  		xhrRequestLast24Hours expected_array
		end

	def xhrRequestLast24Hours(expected_array)
		expected = expected_array.to_json
		xhr :get, :last_connections, :format => :json
		expect(response.body).to eql(expected)
		end
	end
end