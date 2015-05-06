RSpec.describe LocationsController, type: :controller do
  before(:each) do
  	2.times do
    	FactoryGirl.create(:connection_from_Spain)
    end
    
    FactoryGirl.create(:connection_from_France)

    3.times do
      FactoryGirl.create(:connection_from_United_States)
    end
     
    admin = FactoryGirl.create(:admin)
    log_in(admin)
  end

  describe "when access to connections per country filtered by hour" do

  	it "should return connections grouped by contry" do
    	# Descartamos las conexiones de EEUU con las horas
    	expected_array = [
    	  { :_id => { :country => "France" }, :count => 1 },
    	  { :_id => { :country => "Spain" }, :count => 2 }
    	]
    	xhrRequestLocations expected_array, '05:27:04', '11:35:58'
	
    	# Lo mismo pero con visitantes únicos
    	expected_array = [
    	  { :_id => { :country => "France" }, :count => 1 },
    	  { :_id => { :country => "Spain" }, :count => 1 }
    	]
    	xhrRequestLocations expected_array, '05:27:04', '11:35:58', 'true'
	
    	# Ahora descartamos a España mediante la fecha inicio
    	expected_array = [
      	{ :_id => { :country => "France" }, :count => 1 }
    	]
    	xhrRequestLocations expected_array, '05:27:04', '11:35:58', 'false', '15/11/2014'

    	# Ahora descartamos a Francia mediante la fecha fin
    	xhrRequestLocations [], '05:27:04', '11:35:58', 'false', '15/11/2014', '30/11/2014'

    	# Añadimos horas incorrectas
    	expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS"  }
    	xhrRequestLocations expected_array, 'eh:37:09'

    	# Añadimos horas incorrectas
    	expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS"  }
    	xhrRequestLocations expected_array, '05:27:04', '142:344:23'

    	# Añadimos horas inconsistentes
    	expected_array = { "error" => "Start time is lesser than end time"  }
    	xhrRequestLocations expected_array, '12:37:09', '02:00:00'
  	end

    def xhrRequestLocations(expected_array, from='00:00:00', to='23:59:59', unique='false', st_date='14/11/2014', end_date='01/02/2015')
    	expected = expected_array.to_json
    	xhr :get, :countries, :start_date => st_date, :end_date => end_date, :unique_visitors => unique, 
    		:start_hour => from, :end_hour => to, :format => :json
    	expect(response.body).to eql(expected)
  	end
  end

  describe "when access to locations countries_time by time strip" do

  	it "should return locations grouped by year with total amount of listening time" do
  		# Descartamos las conexiones de EEUU con las horas
    	expected_array = [
    	  { :_id => { :country => "France" }, :count => 10 },
    	  { :_id => { :country => "Spain" }, :count => 6 }
    	]
    	xhrRequestLocationsTime expected_array, '05:27:04', '11:35:58'
	
    	# Ahora descartamos a España mediante la fecha inicio
    	expected_array = [
      	{ :_id => { :country => "France" }, :count => 10 }
    	]
    	xhrRequestLocationsTime expected_array, '05:27:04', '11:35:58', '15/11/2014'

    	# Ahora descartamos a Francia mediante la fecha fin
    	xhrRequestLocationsTime [], '05:27:04', '11:35:58', '15/11/2014', '30/11/2014'

    	# Añadimos horas incorrectas
    	expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS"  }
    	xhrRequestLocationsTime expected_array, 'eh:37:09'

    	# Añadimos horas incorrectas
    	expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS"  }
    	xhrRequestLocationsTime expected_array, '05:27:04', '142:344:23'

    	# Añadimos horas inconsistentes
    	expected_array = { "error" => "Start time is lesser than end time"  }
    	xhrRequestLocationsTime expected_array, '12:37:09', '02:00:00'
  	end
  	def xhrRequestLocationsTime(expected_array, from='00:00:00', to='23:59:59', st_date='14/11/2014', end_date='01/02/2015')
     	expected = expected_array.to_json
     	xhr :get, :countries_time, :start_date => st_date, :end_date => end_date, :start_hour => from, :end_hour => to, :format => :json
     	expect(response.body).to eql(expected)
   	end
  end
end