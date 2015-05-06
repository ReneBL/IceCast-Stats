require 'rails_helper'
require 'json'

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

  describe "when access to connections per country" do
  	
  	it "should return connections grouped by country" do
  		# Testeamos un caso sencillo
  		expected_array = [
  			{ :_id => { :country => "France" }, :count => 1 },
      	{ :_id => { :country => "Spain" }, :count => 2 },
      	{ :_id => { :country => "United States" }, :count => 3 }
  		]
  		xhrRequestLocations expected_array

  		# Probamos a obtener solo visitantes únicos
			expected_array = [
  			{ :_id => { :country => "France" }, :count => 1 },
      	{ :_id => { :country => "Spain" }, :count => 1 },
      	{ :_id => { :country => "United States" }, :count => 1 }
  		]
  		xhrRequestLocations expected_array, 'true'

  		# Descartamos las conexiones de España mediante start date
			expected_array = [
  			{ :_id => { :country => "France" }, :count => 1 },
      	{ :_id => { :country => "United States" }, :count => 3 }
  		]
  		xhrRequestLocations expected_array, '', '15/11/2014'

  		# Lo mismo que antes pero agrupando por visitantes únicos
  		expected_array = [
  			{ :_id => { :country => "France" }, :count => 1 },
      	{ :_id => { :country => "United States" }, :count => 1 }
  		]
  		xhrRequestLocations expected_array, 'true', '15/11/2014'

  		# Obtenemos las conexiones descartando a España y EEUU por las fechas inicio y fin
  		expected_array = [
  			{ :_id => { :country => "France" }, :count => 1 }
  		]
  		xhrRequestLocations expected_array, 'false', '15/11/2014', '31/01/2015'

  		# Añadimos fechas incorrectas
  		expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
  		xhrRequestLocations expected_array, 'true', ''

  		# Añadimos fechas incorrectas
  		expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
  		xhrRequestLocations expected_array, 'false', '15/11/2014', '31/782015'
    end

    def xhrRequestLocations(expected_array, unique='', st_date='14/11/2014', end_date='01/02/2015')
      expected = expected_array.to_json
      xhr :get, :countries, :start_date => st_date, :end_date => end_date, :unique_visitors => unique, :format => :json
      expect(response.body).to eql(expected)
    end
  end

  describe "when access to location's countries_time" do

    it "should return total amount of listening time per country" do
      # Testeamos un caso sencillo
      expected_array = [
        { :_id => { :country => "France" }, :count => 10 },
        { :_id => { :country => "Spain" }, :count => 6 },
        { :_id => { :country => "United States" }, :count => 60 }
      ]
      xhrRequestLocationsTime expected_array

      # Descartamos las conexiones de España mediante start date
      expected_array = [
        { :_id => { :country => "France" }, :count => 10 },
        { :_id => { :country => "United States" }, :count => 60 }
      ]
      xhrRequestLocationsTime expected_array, '15/11/2014'

      # Obtenemos las conexiones descartando a España y EEUU por las fechas inicio y fin
      expected_array = [
        { :_id => { :country => "France" }, :count => 10 }
      ]
      xhrRequestLocationsTime expected_array, '15/11/2014', '31/01/2015'

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestLocationsTime expected_array, ''

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestLocationsTime expected_array, '15/11/2014', '31/782015'
    end


    def xhrRequestLocationsTime(expected_array, st_date='14/11/2014', end_date='01/02/2015')
      expected = expected_array.to_json
      xhr :get, :countries_time, :start_date => st_date, :end_date => end_date, :format => :json
      expect(response.body).to eql(expected)
    end
  end

end