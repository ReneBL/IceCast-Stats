require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do
	
	before(:each) do
    2.times do
      FactoryGirl.create(:connection_with_5_seconds)
    end
      
    FactoryGirl.create(:connection_with_20_seconds)
    FactoryGirl.create(:connection_with_30_seconds)
    FactoryGirl.create(:connection_with_60_seconds)
    FactoryGirl.create(:connection_with_120_seconds)
    FactoryGirl.create(:connection_with_200_seconds)
      
    admin = FactoryGirl.create(:admin)
    log_in(admin)
  end

  describe "when filter connections by time strip" do

    it "should return total seconds filtered by time grouped by year" do
      # Caso base: rango de fechas y franja horaria amplio
      total_time_array = [
        { :_id => { :year => 2014 }, :count => 240},
        { :_id => { :year => 2015 }, :count => 200}
      ]
      xhrRequestTotalTime total_time_array

      xhrRequestTotalTime [], '14/11/2014', '14/12/2014'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo todas las conexiones
      total_time_array = [
        { :_id => { :year => 2014 }, :count => 120}
      ]
      xhrRequestTotalTime total_time_array, '11/11/2014', '14/12/2014'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones en noviembre
      total_time_array = [
        { :_id => { :year => 2014 }, :count => 120}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '31/12/2014', 'year', '00:00:00', '04:50:04'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones con rango exacto
      total_time_array = [
        { :_id => { :year => 2014 }, :count => 10}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '31/12/2014', 'year', '06:27:04', '06:27:04'

      total_time_array = [
        { :_id => { :year => 2014 }, :count => 90}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '01/01/2015', 'year', '06:30:05', '12:47:02'

      total_time_array = [
        { :_id => { :year => 2014 }, :count => 90},
        { :_id => { :year => 2015 }, :count => 200}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '01/01/2015', 'year', '06:30:05', '12:47:03'

      total_time_array = { "error" =>  "Start time is greater than end time" }
      xhrRequestTotalTime total_time_array, '01/01/2013', '01/01/2014', 'year', '08:45:33', '05:27:04'

      total_time_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestTotalTime total_time_array, '01/01/2014', '01/01/2015', 'year', '088:5:33', '05:27004'


      # Filtramos por rango de fechas valido pero con una franja horaria fuera de las conexiones
      xhrRequestTotalTime [], '27/03/2013', '01/01/2015', 'year', '12:47:04', '17:30:25'

      # Filtramos con franja horaria valida pero rango de fechas fuera de las conexiones
      xhrRequestTotalTime [], '02/01/2015', '01/01/2016', 'year'
    end

    it "should return total seconds filtered by time grouped by month" do
      # Filtros amplios
      total_time_array = [
        { :_id => { :year => 2014, :month => 3}, :count => 10},
        { :_id => { :year => 2014, :month => 4}, :count => 50},
        { :_id => { :year => 2014, :month => 10}, :count => 60},
        { :_id => { :year => 2014, :month => 11}, :count => 120},
        { :_id => { :year => 2015, :month => 1}, :count => 200}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '01/01/2015', 'month'

      total_time_array = [
        { :_id => { :year => 2014, :month => 3}, :count => 10}
      ]
      xhrRequestTotalTime total_time_array, '27/03/2014', '01/01/2015', 'month', '06:27:04', '06:27:04'

      # Filtros de un mes y franja en rango
      total_time_array = [
      	{ :_id => { :year => 2014, :month => 4}, :count => 30},
      	{ :_id => { :year => 2014, :month => 10}, :count => 60}
      ]
      xhrRequestTotalTime total_time_array, '15/04/2014', '10/11/2014', 'month'

      # Filtro de 2 meses, usuarios unicos y franja en rango
      total_time_array = [
        { :_id => { :year => 2014, :month => 4}, :count => 50},
        { :_id => { :year => 2014, :month => 10}, :count => 60}
      ]
      xhrRequestTotalTime total_time_array, '28/03/2014', '01/01/2015', 'month', '06:27:04', '12:47:02'

      # Filtro que coja todos los meses, pero la franja este fuera
      xhrRequestTotalTime [], '01/01/2014', '01/01/2015', 'month', '00:00:00', '04:50:03'

      total_time_array = { "error" =>  "Start time is greater than end time" }
      xhrRequestTotalTime total_time_array, '01/01/2014', '01/01/2015', 'month', '08:45:33', '05:27:04'

      total_time_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestTotalTime total_time_array, '01/01/2014', '01/01/2015', 'month', '088:5:33', '05:27004'

      # Filtro que coja un mes, pero la franja este fuera
      xhrRequestTotalTime [], '27/03/2014', '14/12/2014', 'month', '07:19:01', '08:45:31'

    end

    it "should return total seconds filtered by time grouped by day" do

      # Filtro que coja todas las conexiones
      total_time_array = [
        { :_id => { :year => 2014, :month => 3, :day => 27}, :count => 10},
        { :_id => { :year => 2014, :month => 4, :day => 5}, :count => 20},
        { :_id => { :year => 2014, :month => 4, :day => 15}, :count => 30},
        { :_id => { :year => 2014, :month => 10, :day => 9}, :count => 60}
      ]
      xhrRequestTotalTime total_time_array, 
          '27/03/2014', '01/01/2015', 'day', '06:27:04', '11:17:04'

      # Filtro que coja solo un dia de noviembre y con un rango que abarque a todas las conexiones en total
      total_time_array = [
        { :_id => { :year => 2014, :month => 11, :day => 11}, :count => 120}
      ]
      xhrRequestTotalTime total_time_array, '11/11/2014', '11/11/2014', 'day'

      # Filtro que coja solo un dia de noviembre, y con un rango que descarte la conexion de las 10
      total_time_array = [
        { :_id => { :year => 2014, :month => 3, :day => 27}, :count => 10},
        { :_id => { :year => 2014, :month => 11, :day => 11}, :count => 120}
      ]
      xhrRequestTotalTime total_time_array, 
          '27/03/2014', '01/01/2015', 'day', '04:50:04', '06:27:04'

      total_time_array = { "error" =>  "Start time is greater than end time" }
      xhrRequestTotalTime total_time_array, '14/11/2013', '14/11/2013', 'day', '10:58:00', '05:27:03'

      total_time_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestTotalTime total_time_array, '01/01/2013', '01/01/2014', 'day', '088:5:33', '05:27004'

      xhrRequestTotalTime [], '15/11/2013', '01/01/2014', 'day', '00:00:00', '04:50:03'

    end

    def xhrRequestTotalTime(expected_array, st_date='27/03/2014', end_date='01/01/2015', group_by='year', 
      from="00:00:00", to="23:59:59")

      expected = expected_array.to_json
      xhr :get, :total_seconds_grouped, :start_date => st_date, :end_date => end_date, :group_by => group_by, :start_hour => from, :end_hour => to
      expect(response.body).to eql(expected)
    end
  end
end