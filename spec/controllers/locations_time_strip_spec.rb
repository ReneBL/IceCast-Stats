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

RSpec.describe LocationsController, type: :controller do
  
  describe "when access to connections per country filtered by hour" do

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
    	expected_array = { "error" => "Start time is greater than end time"  }
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

  	it "should return locations grouped by country with total amount of listening time" do
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
    	expected_array = { "error" => "Start time is greater than end time"  }
    	xhrRequestLocationsTime expected_array, '12:37:09', '02:00:00'
  	end
  	def xhrRequestLocationsTime(expected_array, from='00:00:00', to='23:59:59', st_date='14/11/2014', end_date='01/02/2015')
     	expected = expected_array.to_json
     	xhr :get, :countries_time, :start_date => st_date, :end_date => end_date, :start_hour => from, :end_hour => to, :format => :json
     	expect(response.body).to eql(expected)
   	end
  end

  describe "when access to locations regions by time strip" do

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

    it "should return locations grouped by region" do
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Galicia"}, :count => 3 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '03:10:39'

      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Galicia"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '03:10:39', 'true'
  
      # Descartamos a Galicia con la fecha de inicio
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Extremadura"}, :count => 2 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '17:55:42', 'false', '18/07/2014'

      # Descartamos a Galicia con la fecha de inicio y agrupamos
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Extremadura"}, :count => 1 },
        { :_id => { :region => "Madrid"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '17:55:42', 'true', '18/07/2014'

      # Descartamos a Madrid con la fecha de fin
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 },
        { :_id => { :region => "Extremadura"}, :count => 2 },
        { :_id => { :region => "Galicia"}, :count => 3 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '17:55:42', 'false', '17/07/2014', '10/02/2015'

      # Descartamos a Madrid con la fecha de inicio y agrupamos
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 },
        { :_id => { :region => "Extremadura"}, :count => 1 },
        { :_id => { :region => "Galicia"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '00:27:04', '17:55:42', 'true', '17/07/2014', '10/02/2015'

      # Descartamos todo menos Cataluña mediante las horas
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 3 }
      ]
      xhrRequestRegions expected_array, '03:10:39', '03:10:39'

      # Descartamos todo menos Cataluña mediante las horas
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '03:10:39', '03:10:39', 'true'

      expected_array = [
        { :_id => { :region => "New Jersey"}, :count => 1 }
      ]
      xhrRequestRegions expected_array, '13:25:41', '13:25:41', 'false', '17/07/2014', '11/02/2015', 'United States'

      xhrRequestRegions [], '13:25:42', '13:25:45', 'false', '17/07/2014', '11/02/2015', 'United States'

      xhrRequestRegions [], '03:10:40', '09:40:00'

      # Añadimos horas incorrectas
      expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestRegions expected_array, 'eh:37:09'

      # Añadimos horas incorrectas
      expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestRegions expected_array, '05:27:04', '142:344:23'

      # Añadimos horas inconsistentes
      expected_array = { "error" => "Start time is greater than end time" }
      xhrRequestRegions expected_array, '12:37:09', '02:00:00'

      expected_array = { "error" => "Invalid country" }
      xhrRequestRegions expected_array, '00:30:09', '09:10:00', 'false', '17/07/2014', '11/02/2015', ''

      expected_array = { "error" => "Invalid country" }
      xhrRequestRegions expected_array, '00:30:09', '09:10:00', 'false', '17/07/2014', '11/02/2015', ' '
    
    end
    def xhrRequestRegions(expected_array, from='00:00:00', to='23:59:59', unique='', st_date='17/07/2014',
        end_date='11/02/2015', country='Spain')

      expected = expected_array.to_json
      xhr :get, :regions, :start_date => st_date, :end_date => end_date, :start_hour => from,
         :end_hour => to, :country => country, :unique_visitors => unique, :format => :json
      expect(response.body).to eql(expected)
    end
  end

  describe "when access to locations regions_time by time strip" do

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

    it "should return locations grouped by region" do
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 60 },
        { :_id => { :region => "Galicia"}, :count => 30 }
      ]
      xhrRequestRegionsTime expected_array, '00:27:04', '03:10:39'
  
      # Descartamos a Galicia con la fecha de inicio
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 60 },
        { :_id => { :region => "Extremadura"}, :count => 30 },
        { :_id => { :region => "Madrid"}, :count => 8 }
      ]
      xhrRequestRegionsTime expected_array, '00:27:04', '17:55:42', '18/07/2014'

      # Descartamos a Madrid con la fecha de fin
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 60 },
        { :_id => { :region => "Extremadura"}, :count => 30 },
        { :_id => { :region => "Galicia"}, :count => 30 }
      ]
      xhrRequestRegionsTime expected_array, '00:27:04', '17:55:42', '17/07/2014', '10/02/2015'

      # Descartamos todo menos Cataluña mediante las horas
      expected_array = [
        { :_id => { :region => "Cataluña"}, :count => 60 }
      ]
      xhrRequestRegionsTime expected_array, '03:10:39', '03:10:39'

      expected_array = [
        { :_id => { :region => "New Jersey"}, :count => 9 }
      ]
      xhrRequestRegionsTime expected_array, '13:25:41', '13:25:41', '17/07/2014', '11/02/2015', 'United States'

      xhrRequestRegionsTime [], '13:25:42', '13:25:45', '17/07/2014', '11/02/2015', 'United States'

      xhrRequestRegionsTime [], '03:10:40', '09:40:00'

      # Añadimos horas incorrectas
      expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestRegionsTime expected_array, 'eh:37:09'

      # Añadimos horas incorrectas
      expected_array = { "error" => "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestRegionsTime expected_array, '05:27:04', '142:344:23'

      # Añadimos horas inconsistentes
      expected_array = { "error" => "Start time is greater than end time" }
      xhrRequestRegionsTime expected_array, '12:37:09', '02:00:00'

      expected_array = { "error" => "Invalid country" }
      xhrRequestRegionsTime expected_array, '00:30:09', '09:10:00', '17/07/2014', '11/02/2015', ''

      expected_array = { "error" => "Invalid country" }
      xhrRequestRegionsTime expected_array, '00:30:09', '09:10:00', '17/07/2014', '11/02/2015', ' '
    
    end
    def xhrRequestRegionsTime(expected_array, from='00:00:00', to='23:59:59', st_date='17/07/2014', end_date='11/02/2015', country='Spain')

      expected = expected_array.to_json
      xhr :get, :regions_time, :start_date => st_date, :end_date => end_date, :start_hour => from, :end_hour => to, :country => country, :format => :json
      expect(response.body).to eql(expected)
    end
  end

  describe "when access to location's cities_time" do

    before(:each) do
      3.times do
        FactoryGirl.create(:connection_from_Coruña)
      end
      FactoryGirl.create(:connection_from_Laracha)
      FactoryGirl.create(:connection_from_Barcelona)

      2.times do
        FactoryGirl.create(:connection_from_Valencia)
      end

      3.times do
        FactoryGirl.create(:connection_from_Bilbao)
      end

      FactoryGirl.create(:connection_from_Unknown_all)
      FactoryGirl.create(:connection_from_Unknown_city_region)
      FactoryGirl.create(:connection_from_Unknown_country_region)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return total amount of listening time per city" do
      expected_array = [
        { :_id => { :city => "A Coruña"}, :count => 60 },
        { :_id => { :city => "Laracha"},  :count => 10 }
      ]
      xhrRequestCitiesTime expected_array, 'Galicia', 'Spain'

      expected_array = [
        { :_id => { :city => "Laracha"}, :count => 10 }
      ]
      xhrRequestCitiesTime expected_array, 'Galicia', 'Spain', '00:00:00', '04:57:09'

      xhrRequestCitiesTime [], 'Comunidad Valenciana', 'Spain', '00:00:00', '00:00:00'

      xhrRequestCitiesTime [], 'BlaBla'

      expected_array = {"error" => "Invalid region"}
      xhrRequestCitiesTime expected_array, ''

      xhrRequestCitiesTime [], 'Galicia', 'BlaBla'

      expected_array = { "error" => "Start time is greater than end time"  }
      xhrRequestCitiesTime expected_array, 'Cataluña', 'Spain', '13:34:10', '10:20:19'

      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestCitiesTime expected_array, 'Cataluña', 'Spain', '10:34:10', '12:20:19', '/02/2010'

      expected_array = { "error" => "One date is invalid. Correct format: d/m/Y"  }
      xhrRequestCitiesTime expected_array, 'Cataluña', 'Spain', '10:34:10', '12:20:19', '10/02/2010', '34/29//10'
    end

    def xhrRequestCitiesTime(expected_array, region, country='Spain', st_hour="00:00:00", end_hour="23:59:59", 
      st_date='14/11/2014', end_date='11/02/2015')
      
      expected = expected_array.to_json
      xhr :get, :cities_time, :start_date => st_date, :end_date => end_date, :start_hour => st_hour, 
        :end_hour => end_hour, :country => country, :region => region, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end