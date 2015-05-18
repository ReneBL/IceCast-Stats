require 'rails_helper'
require 'json'

RSpec.describe RankingController, type: :controller do

	before(:each) do
		FactoryGirl.create(:connection_with_none_referrer)
		FactoryGirl.create(:connection_with_cuacfm_directo)
    FactoryGirl.create(:connection_with_cuacfm_directo2)
		FactoryGirl.create(:connection_with_url_2)
		FactoryGirl.create(:connection_with_url_3)
		FactoryGirl.create(:connection_with_url_4)
		FactoryGirl.create(:connection_with_url_5)
    FactoryGirl.create(:connection_with_url_6)
    FactoryGirl.create(:connection_with_url_7)
    FactoryGirl.create(:connection_with_url_8)
    FactoryGirl.create(:connection_with_url_9)
    FactoryGirl.create(:connection_with_url_10)

    admin = FactoryGirl.create(:admin)
    log_in(admin)
	end

  describe "when access to ranking of user agent" do
  	it "should return ranking of user agent paginated" do

  		expected_array = [
  			{:_id => "http://cuacfm.org/directo", :listeners => 2, :bytes => 28, :time => 66},
        {:_id => "http://url9.com", :listeners => 1, :bytes => 33, :time => 50},
        {:_id => "http://url8.com", :listeners => 1, :bytes => 24, :time => 46},
        {:_id => "http://url7.com", :listeners => 1, :bytes => 19, :time => 21},
        {:_id => "http://url6.com", :listeners => 1, :bytes => 18, :time => 28},
        {:_id => "http://url2.com", :listeners => 1, :bytes => 15, :time => 20},
        {:_id => "http://url4.com", :listeners => 1, :bytes => 13, :time => 25},
        {:_id => "http://url10.com", :listeners => 1, :bytes => 12, :time => 90},
        {:_id => "http://url5.com", :listeners => 1, :bytes => 11, :time => 30},
        {:_id => "http://url3.com", :listeners => 1, :bytes => 8, :time => 16}
  		]
  		xhrRequestTopLinksRanking expected_array

  		expected_array = [
        {:_id => "http://url9.com", :listeners => 1, :bytes => 33, :time => 50},
        {:_id => "http://url8.com", :listeners => 1, :bytes => 24, :time => 46},
        {:_id => "http://url7.com", :listeners => 1, :bytes => 19, :time => 21},
        {:_id => "http://url6.com", :listeners => 1, :bytes => 18, :time => 28},
        {:_id => "http://url2.com", :listeners => 1, :bytes => 15, :time => 20},
        {:_id => "http://url4.com", :listeners => 1, :bytes => 13, :time => 25},
        {:_id => "http://url10.com", :listeners => 1, :bytes => 12, :time => 90},
        {:_id => "http://url5.com", :listeners => 1, :bytes => 11, :time => 30},
        {:_id => "http://cuacfm.org/directo", :listeners => 1, :bytes => 10, :time => 10},
        {:_id => "http://url3.com", :listeners => 1, :bytes => 8, :time => 16}
      ]
  		xhrRequestTopLinksRanking expected_array, '14/11/2014'

  		xhrRequestTopLinksRanking [], '31/01/2015', '27/11/2015'
  	end
  end

  describe "when access to ranking of user agent filtered by time strip" do
    it "should return ranking of user agent paginated" do

      expected_array = [
        {:_id => "http://cuacfm.org/directo", :listeners => 2, :bytes => 28, :time => 66},
        {:_id => "http://url9.com", :listeners => 1, :bytes => 33, :time => 50},
        {:_id => "http://url8.com", :listeners => 1, :bytes => 24, :time => 46},
        {:_id => "http://url7.com", :listeners => 1, :bytes => 19, :time => 21},
        {:_id => "http://url6.com", :listeners => 1, :bytes => 18, :time => 28},
        {:_id => "http://url2.com", :listeners => 1, :bytes => 15, :time => 20},
        {:_id => "http://url4.com", :listeners => 1, :bytes => 13, :time => 25},
        {:_id => "http://url10.com", :listeners => 1, :bytes => 12, :time => 90},
        {:_id => "http://url5.com", :listeners => 1, :bytes => 11, :time => 30},
        {:_id => "http://url3.com", :listeners => 1, :bytes => 8, :time => 16}
      ]
      xhrRequestTopLinksRankingTime expected_array

      expected_array = [
        {:_id => "http://url9.com", :listeners => 1, :bytes => 33, :time => 50},
        {:_id => "http://url8.com", :listeners => 1, :bytes => 24, :time => 46},
        {:_id => "http://url7.com", :listeners => 1, :bytes => 19, :time => 21},
        {:_id => "http://url6.com", :listeners => 1, :bytes => 18, :time => 28},
        {:_id => "http://url2.com", :listeners => 1, :bytes => 15, :time => 20},
        {:_id => "http://url4.com", :listeners => 1, :bytes => 13, :time => 25},
        {:_id => "http://url10.com", :listeners => 1, :bytes => 12, :time => 90},
        {:_id => "http://url5.com", :listeners => 1, :bytes => 11, :time => 30},
        {:_id => "http://cuacfm.org/directo", :listeners => 1, :bytes => 10, :time => 10},
        {:_id => "http://url3.com", :listeners => 1, :bytes => 8, :time => 16}
      ]
      xhrRequestTopLinksRankingTime expected_array, "01:11:45"

      xhrRequestTopLinksRankingTime [], "00:00:00", "01:11:43"
    end
  end

  def xhrRequestTopLinksRanking(expected_array, st_date='11/11/2014', end_date='30/01/2015')
  	expected = expected_array.to_json
    xhr :get, :top_links_ranking, :start_date => st_date, :end_date => end_date, :format => :json
    expect(response.body).to eql(expected)
  end

  def xhrRequestTopLinksRankingTime(expected_array, st_hour="00:00:00", end_hour="23:59:59", st_date='11/11/2014', 
    end_date='30/01/2015')
    expected = expected_array.to_json
    xhr :get, :top_links_ranking, :start_date => st_date, :end_date => end_date, :start_hour => st_hour,
      :end_hour => end_hour, :format => :json
    expect(response.body).to eql(expected)
  end
end