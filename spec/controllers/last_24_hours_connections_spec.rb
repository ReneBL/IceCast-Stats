require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do

	before(:each) do
			FactoryGirl.create(:listening_sin_etiquetas)
			FactoryGirl.create(:listening_sin_etiquetas_fantasma_accidental)
			
			FactoryGirl.create(:listening_la_enredadera)
			FactoryGirl.create(:listening_FolkInTrio_ElRinconcito)
			FactoryGirl.create(:listening_FolkInTrio)
			FactoryGirl.create(:connection_out_of_24_hours_before)
			FactoryGirl.create(:connection_out_of_24_hours_after)
			
			admin = FactoryGirl.create(:admin)
			log_in(admin)
		end
	
	describe "when access to last 24 hours connections" do
		it "should return number of connections in last 24 hours" do
			expected_array = [
        {:_id => {:program => "Sin Etiquetas", :datetime => "2015-04-30 22:00:00"}, :listeners => 1},
        {:_id => {:program => "Sin Etiquetas", :datetime => "2015-04-30 23:30:00"}, :listeners => 1},
        {:_id => {:program => "Fantasma accidental", :datetime => "2015-04-30 23:30:00"}, :listeners => 1},
        {:_id => "Folk in trio", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Informativos", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Radiocassette", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Sin Etiquetas", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
      ]
  		xhrRequestPrograms expected_array, '31/03/2015', '15/05/2015', 'true'
		end

	def xhrRequestLast24Hours(expected_array, st_date='31/03/2015', end_date='15/05/2015')
		expected = expected_array.to_json
		xhr :get, :last_connections, :start_date => st_date, :end_date => end_date, :format => :json
		expect(response.body).to eql(expected)
		end
	end
end