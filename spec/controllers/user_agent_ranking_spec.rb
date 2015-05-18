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

  describe "when access to ranking of user agent" do
  	it "should return all ranking without pagination" do
  		expected_array = [
  			{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
  			{:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
        {:_id => "iTunes/9.1.1", :listeners => 1, :bytes => 40, :time => 20},
        {:_id => "Mozilla Firefox", :listeners => 1, :bytes => 10, :time => 5}
  		]
  		expected = expected_array.to_json
    	xhr :get, :user_agent_ranking, :start_date => '14/11/2014', :end_date => '27/11/2015', :format => :json
    	expect(response.body).to eql(expected)
  	end

  	it "should return ranking of user agent paginated" do

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
        {:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
        {:_id => "iTunes/9.1.1", :listeners => 1, :bytes => 40, :time => 20},
        {:_id => "Mozilla Firefox", :listeners => 1, :bytes => 10, :time => 5},
        {:hasMore => false}
  		]
  		xhrRequestUserAgentRanking expected_array, '14/11/2014', '27/11/2015', 1, 5

  		xhrRequestUserAgentRanking [], '14/11/2014', '27/11/2015', 6, 5
  	end

  	it "should return ranking of user agent paginated and filtered by date" do
  		expected_array = [
  			{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
        {:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestUserAgentRanking expected_array, '01/01/2015'

  		expected_array = [
  			{:_id => "Google Chrome", :listeners => 5, :bytes => 150, :time => 75},
        {:_id => "Safari", :listeners => 2, :bytes => 40, :time => 20},
        {:hasMore => true}
  		]
  		xhrRequestUserAgentRanking expected_array, '01/01/2015', '27/11/2015', 0, 2

  		expected_array = [
  			{:_id => "Winamp", :listeners => 1, :bytes => 11356, :time => 16},
        {:_id => "VLC Media Player", :listeners => 1, :bytes => 345, :time => 6},
        {:hasMore => false}
  		]
  		xhrRequestUserAgentRanking expected_array, '01/01/2015', '27/11/2015', 2, 2

  		xhrRequestUserAgentRanking [], '10/10/2014', '13/11/2014'

  		xhrRequestUserAgentRanking [], '28/11/2015', '12/12/2015'

      error = {"error" => "Not valid indexes"}
      xhrRequestUserAgentRanking error, '14/11/2014', '25/03/2015', -1, 5

      error = {"error" => "Not valid indexes"}
      xhrRequestUserAgentRanking error, '14/11/2014', '25/03/2015', 1, -5

      error = {"error" => "Not valid indexes"}
      xhrRequestUserAgentRanking error, '14/11/2014', '25/03/2015', 1, 0

      error = {"error" => "Not valid indexes"}
      xhrRequestUserAgentRanking error, '14/11/2014', '25/03/2015', 1, nil

      error = {"error" => "Not valid indexes"}
      xhrRequestUserAgentRanking error, '14/11/2014', '25/03/2015', nil, 1
  	end

  end

  def xhrRequestUserAgentRanking(expected_array, st_date='14/11/2014', end_date='27/11/2015', start_index=0, count=5)
  	expected = expected_array.to_json
    xhr :get, :user_agent_ranking, :start_date => st_date, :end_date => end_date, :start_index => start_index,
    	:count => count, :format => :json
    expect(response.body).to eql(expected)
  end
end