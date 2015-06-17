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
        {:_id => "http://url10.com", :time => 90, :bytes => 12, :listeners => 1},
        {:_id => "http://cuacfm.org/directo", :time => 66, :bytes => 28, :listeners => 2},
        {:_id => "http://url9.com", :time => 50, :bytes => 33, :listeners => 1},
        {:_id => "http://url8.com", :time => 46, :bytes => 24, :listeners => 1},
        {:_id => "http://url5.com", :time => 30, :bytes => 11, :listeners => 1},
        {:_id => "http://url6.com", :time => 28, :bytes => 18, :listeners => 1},
        {:_id => "http://url4.com", :time => 25, :bytes => 13, :listeners => 1},
        {:_id => "http://url7.com", :time => 21, :bytes => 19, :listeners => 1},
        {:_id => "http://url2.com", :time => 20, :bytes => 15, :listeners => 1},
        {:_id => "http://url3.com", :time => 16, :bytes => 8, :listeners => 1}
  		]
  		xhrRequestTopLinksRanking expected_array

  		expected_array = [
        {:_id => "http://url10.com", :time => 90, :bytes => 12, :listeners => 1},
        {:_id => "http://url9.com", :time => 50, :bytes => 33, :listeners => 1},
        {:_id => "http://url8.com", :time => 46, :bytes => 24, :listeners => 1},
        {:_id => "http://url5.com", :time => 30, :bytes => 11, :listeners => 1},
        {:_id => "http://url6.com", :time => 28, :bytes => 18, :listeners => 1},
        {:_id => "http://url4.com", :time => 25, :bytes => 13, :listeners => 1},
        {:_id => "http://url7.com", :time => 21, :bytes => 19, :listeners => 1},
        {:_id => "http://url2.com", :time => 20, :bytes => 15, :listeners => 1},
        {:_id => "http://url3.com", :time => 16, :bytes => 8, :listeners => 1},
        {:_id => "http://cuacfm.org/directo", :time => 10, :bytes => 10, :listeners => 1}
      ]
  		xhrRequestTopLinksRanking expected_array, '14/11/2014'

  		xhrRequestTopLinksRanking [], '31/01/2015', '27/11/2015'
  	end
  end

  describe "when access to ranking of user agent filtered by time strip" do
    it "should return ranking of user agent paginated" do

      expected_array = [
        {:_id => "http://url10.com", :time => 90, :bytes => 12, :listeners => 1},
        {:_id => "http://cuacfm.org/directo", :time => 66, :bytes => 28, :listeners => 2},
        {:_id => "http://url9.com", :time => 50, :bytes => 33, :listeners => 1},
        {:_id => "http://url8.com", :time => 46, :bytes => 24, :listeners => 1},
        {:_id => "http://url5.com", :time => 30, :bytes => 11, :listeners => 1},
        {:_id => "http://url6.com", :time => 28, :bytes => 18, :listeners => 1},
        {:_id => "http://url4.com", :time => 25, :bytes => 13, :listeners => 1},
        {:_id => "http://url7.com", :time => 21, :bytes => 19, :listeners => 1},
        {:_id => "http://url2.com", :time => 20, :bytes => 15, :listeners => 1},
        {:_id => "http://url3.com", :time => 16, :bytes => 8, :listeners => 1}
      ]
      xhrRequestTopLinksRankingTime expected_array

      expected_array = [
        {:_id => "http://url10.com", :time => 90, :bytes => 12, :listeners => 1},
        {:_id => "http://url9.com", :time => 50, :bytes => 33, :listeners => 1},
        {:_id => "http://url8.com", :time => 46, :bytes => 24, :listeners => 1},
        {:_id => "http://url5.com", :time => 30, :bytes => 11, :listeners => 1},
        {:_id => "http://url6.com", :time => 28, :bytes => 18, :listeners => 1},
        {:_id => "http://url4.com", :time => 25, :bytes => 13, :listeners => 1},
        {:_id => "http://url7.com", :time => 21, :bytes => 19, :listeners => 1},
        {:_id => "http://url2.com", :time => 20, :bytes => 15, :listeners => 1},
        {:_id => "http://url3.com", :time => 16, :bytes => 8, :listeners => 1},
        {:_id => "http://cuacfm.org/directo", :time => 10, :bytes => 10, :listeners => 1}
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