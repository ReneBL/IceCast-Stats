require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do

	before(:each) do
		2.times do
			FactoryGirl.create(:friday_listening_Informativos_Radiocassette_Sin_Etiq)
		end

		3.times do
			FactoryGirl.create(:tuesday_listening_Spoiler)
		end

		FactoryGirl.create(:monday_listening_FolkInTrio_ElRinconcito)
		FactoryGirl.create(:connection_out_of_schedule)
		FactoryGirl.create(:not_scheduled_source)

    admin = FactoryGirl.create(:admin)
    log_in(admin)
	end

  describe "when access to program grouped connections" do
  	it "should return all grouped connections" do
  		expected_array = [
  			{:_id => "El Rinconcito", :listeners => 1, :avg => 3000.0, :time => 3000},
  			{:_id => "Folk in trio", :listeners => 1, :avg => 600.0, :time => 600},
        {:_id => "Informativos", :listeners => 2, :avg => 3000.0, :time => 6000},
  			{:_id => "Radiocassette", :listeners => 2, :avg => 3600.0, :time => 7200},
        {:_id => "Sin Etiquetas", :listeners => 2, :avg => 2400.0, :time => 4800},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
  		]
    	xhrRequestPrograms expected_array
  	end

  	it "should return programs filtered by date" do

      expected_array = [
        {:_id => "Informativos", :listeners => 2, :avg => 3000.0, :time => 6000},
        {:_id => "Radiocassette", :listeners => 2, :avg => 3600.0, :time => 7200},
        {:_id => "Sin Etiquetas", :listeners => 2, :avg => 2400.0, :time => 4800},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
      ]
  		xhrRequestPrograms expected_array, '06/04/2015'

      expected_array = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 3000.0, :time => 3000},
        {:_id => "Folk in trio", :listeners => 1, :avg => 600.0, :time => 600},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
      ]
  		xhrRequestPrograms expected_array, '05/04/2015', '14/05/2015'

      expected_array = [
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
      ]
      xhrRequestPrograms expected_array, '06/04/2015', '14/05/2015'

      xhrRequestPrograms [], '06/04/2014', '14/05/2014'
  	end

  	it "should return programs filtered by date grouped by visitors" do
      expected_array = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Folk in trio", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Informativos", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Radiocassette", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Sin Etiquetas", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
      ]
  		xhrRequestPrograms expected_array, '31/03/2015', '15/05/2015', 'true'

      expected_array = [
        {:_id => "Informativos", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Radiocassette", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Sin Etiquetas", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
      ]
      xhrRequestPrograms expected_array, '06/04/2015', '15/05/2015', 'true'

  		expected_array = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Folk in trio", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
      ]
      xhrRequestPrograms expected_array, '05/04/2015', '14/05/2015', 'true'

      xhrRequestPrograms [], '06/04/2014', '14/05/2014', 'true'
  	end

  end

  def xhrRequestPrograms(expected_array, st_date='31/03/2015', end_date='15/05/2015', unique='false')
  	expected = expected_array.to_json
    xhr :get, :programs, :start_date => st_date, :end_date => end_date, :unique_visitors => unique, 
      :format => :json
    expect(response.body).to eql(expected)
  end
end