require 'rails_helper'
require 'json'

RSpec.describe LocationsController, type: :controller do

  describe "when access to connections per country" do
  	
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

  describe "when access to location's connections per regions of country" do

    before(:each) do
    	3.times do
      	FactoryGirl.create(:connection_from_Galicia)
    	end
    	FactoryGirl.create(:connection_from_Madrid)

    	2.times do
    		FactoryGirl.create(:connection_from_Extremadura)
    	end

    	3.times do
      	FactoryGirl.create(:connection_from_Cataluña)
    	end

    	FactoryGirl.create(:connection_from_New_Jersey)
      
    	admin = FactoryGirl.create(:admin)
    	log_in(admin)
  	end

    it "should return total amount of connections per region" do
      # Testeamos un caso sencillo
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Extremadura"},  :count => 2 },
        { :_id => { :region => "Galicia"}, :count => 3 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array

      # Agrupamos por visitantes
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Extremadura"}, :count => 1 },
        { :_id => { :region => "Galicia"}, :count => 1 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '17/07/2014', '11/02/2015', 'true'

      # Descartamos las conexiones de Galicia mediante fecha inicio
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Extremadura"}, :count => 2 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '01/12/2014'

      # Descartamos las conexiones de Galicia mediante fecha inicio y agrupamos
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Extremadura"}, :count => 1 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '01/12/2014', '11/02/2015', 'true'

      # Descartamos Galicia y Madrid por fecha inicio y fin
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Extremadura"}, :count => 2 }
      ]
      xhrRequestRegions expected_array, '01/12/2014', '10/02/2015'

      # Descartamos Galicia y Madrid por fecha inicio y fin y agrupamos
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Extremadura"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '01/12/2014', '10/02/2015', 'true'

      # Cogemos solo las conexiones de Galicia
      expected_array = [
        { :_id => { :region => "Galicia"}, :count => 3 }
      ]
      xhrRequestRegions expected_array, '17/07/2014', '17/07/2014'

      # Cogemos solo las conexiones de Galicia y agrupamos
      expected_array = [
        { :_id => { :region => "Galicia"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '17/07/2014', '17/07/2014', 'true'

      # Cogemos solo las conexiones de Galicia y agrupamos
      expected_array = [
        { :_id => { :region => "New Jersey"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '10/02/2015', '10/02/2015', 'false', 'United States'

      xhrRequestRegions [], '12/02/2015', '13/02/2015'

      xhrRequestRegions [], '12/02/2015', '13/02/2015', 'true'

      xhrRequestRegions [], '12/02/2014', '16/07/2014'

      xhrRequestRegions [], '12/02/2014', '16/07/2014', 'true'

      xhrRequestRegions [], '12/02/2014', '16/07/2014', 'false', 'España'

      xhrRequestRegions [], '12/02/2014', '16/07/2014', 'true', 'Italy'

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestRegions expected_array, ''

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestRegions expected_array, '15/11/2014', '31/782015'

      expected_array = { "error" => "Invalid country"  }
      xhrRequestRegions expected_array, '17/07/2014', '11/02/2015', 'false', ''

      expected_array = { "error" => "Invalid country"  }
      xhrRequestRegions expected_array, '17/07/2014', '11/02/2015', 'true', ' '
    end

    it "should return all distinct countries" do
    	expected_array = ["Spain", "United States"]
      xhrRequestAllCountries expected_array
    end

    def xhrRequestRegions(expected_array, st_date='17/07/2014', end_date='11/02/2015', unique='', country='Spain')
      expected = expected_array.to_json
      xhr :get, :regions, :start_date => st_date, :end_date => end_date, :unique_visitors => unique,
      	:country => country, :format => :json
      expect(response.body).to eql(expected)
    end

    def xhrRequestAllCountries expected_array
    	expected = expected_array.to_json
    	xhr :get, :get_countries, :format => :json
    	expect(response.body).to eql(expected)
    end
  end

  describe "when access to location's regions_time" do

    before(:each) do
      3.times do
        FactoryGirl.create(:connection_from_Galicia)
      end
      FactoryGirl.create(:connection_from_Madrid)

      2.times do
        FactoryGirl.create(:connection_from_Extremadura)
      end

      3.times do
        FactoryGirl.create(:connection_from_Cataluña)
      end

      FactoryGirl.create(:connection_from_New_Jersey)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return total amount of listening time per region" do
      # Testeamos un caso sencillo
      expected_array = [
        { :_id => { :region => "Cataluña" }, :count => 60 },
        { :_id => { :region => "Extremadura" }, :count => 30 },
        { :_id => { :region => "Galicia" }, :count => 30 },
        { :_id => { :region => "Madrid" }, :count => 8 }
      ]
      xhrRequestRegionsTime expected_array

      # Descartamos las conexiones de Galicia mediante start date
      expected_array = [
        { :_id => { :region => "Cataluña" }, :count => 60 },
        { :_id => { :region => "Extremadura" }, :count => 30 },
        { :_id => { :region => "Madrid" }, :count => 8 }
      ]
      xhrRequestRegionsTime expected_array, '01/12/2014'

      # Obtenemos las conexiones descartando a Galicia y Madrid por las fechas inicio y fin
      expected_array = [
        { :_id => { :region => "Cataluña" }, :count => 60 },
        { :_id => { :region => "Extremadura" }, :count => 30 }
      ]
      xhrRequestRegionsTime expected_array, '01/12/2014', '01/02/2015'

      expected_array = [
        { :_id => { :region => "New Jersey" }, :count => 9 }
      ]
      xhrRequestRegionsTime expected_array, '10/02/2015', '10/02/2015', 'United States'

      xhrRequestRegionsTime [], '11/07/2014', '16/07/2014'

      xhrRequestRegionsTime [], '11/02/2015', '11/02/2015', 'United States'

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestRegionsTime expected_array, ''

      # Añadimos fechas incorrectas
      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestRegionsTime expected_array, '15/11/2014', '31/782015'
    end

    it "should return all regions from a country" do
      expected = ["Cataluña", "Extremadura", "Galicia", "Madrid"]
      xhrRequestAllRegions expected, 'Spain'

      expected = ["New Jersey"]
      xhrRequestAllRegions expected, 'United States'

      xhrRequestAllRegions [], 'Dominican Republic'

      expected = {"error" => "Invalid country"}
      xhrRequestAllRegions expected, ''

      expected = {"error" => "Invalid country"}
      xhrRequestAllRegions expected, ' '
    end


    def xhrRequestRegionsTime(expected_array, st_date='17/07/2014', end_date='11/02/2015', country='Spain')
      expected = expected_array.to_json
      xhr :get, :regions_time, :start_date => st_date, :end_date => end_date, :country => country, :format => :json
      expect(response.body).to eql(expected)
    end

    def xhrRequestAllRegions(expected_array, country)
      expected = expected_array.to_json
      xhr :get, :get_regions, :country => country, :format => :json
      expect(response.body).to eql(expected)
    end
  end

end