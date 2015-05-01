require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do
  describe "when filter connections by time strip" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_at_5_27_on_2013)
      end
      FactoryGirl.create(:connection_at_7_19_on_2013)
      FactoryGirl.create(:connection_at_8_45_on_2014)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return connections filtered by time grouped by year" do
      # Caso base: rango de fechas y franja horaria amplio
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 3},
        { :_id => { :year => 2014 }, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array

      # Filtramos por rango de fechas solo en 2013 y la franja cubriendo todas las conexiones
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 3}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '14/12/2013', 'year', 'false'

      # Lo mismo que lo anterior pero con visitantes unicos
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '14/12/2013', 'year', 'true'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo todas las conexiones
      connections_between_dates_hours_array = [
        { :_id => { :year => 2014 }, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '01/01/2014', '02/01/2014', 'year', 'true'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones en noviembre
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '02/01/2014', 'year', 'false', '05:27:04', '07:18:59'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones con rango exacto
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '02/01/2014', 'year', 'false', '05:27:04', '05:27:04'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones con rango exacto
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '02/01/2014', 'year', 'true', '05:27:04', '05:27:04'

      # Filtramos por rango de fechas solo en 2014 y la franja cubriendo solo conexiones en noviembre y diciembre
      connections_between_dates_hours_array = [
        { :_id => { :year => 2013 }, :count => 2},
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_hours_array, '14/11/2013', '02/01/2014', 'year', 'true', '05:27:04', '07:19:00'

      connections_between_dates_array = { "error" =>  "Start time is lesser than end time" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_array, '01/01/2013', '01/01/2014', 'year', 'false', '08:45:33', '05:27:04'

      connections_between_dates_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_array, '01/01/2013', '01/01/2014', 'year', 'true', '088:5:33', '05:27004'


      # Filtramos por rango de fechas valido pero con una franja horaria fuera de las conexiones
      xhrRequestConnBetweenDatesAndHours [], '01/01/2013', '01/01/2014', 'year', 'false', '12:00:00', '17:30:25'

      # Filtramos con franja horaria valida pero rango de fechas fuera de las conexiones
      xhrRequestConnBetweenDatesAndHours [], '02/01/2014', '01/01/2015', 'year', 'false'
    end

    it "should return connections filtered by time grouped by month" do
      # Filtros amplios
      connections_between_dates_month_array = [
        { :_id => { :year => 2013, :month => 11}, :count => 2},
        { :_id => { :year => 2013, :month => 12}, :count => 1},
        { :_id => { :year => 2014, :month => 1}, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_month_array, '01/01/2013', '01/01/2014', 'month', 'false', '05:27:04', '08:45:32'

      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_month_array, '01/01/2013', '01/01/2014', 'month', 'false', '08:45:32', '08:45:32'

      # Filtros de un mes y franja en rango
      connections_between_dates_month_array = [
        { :_id => { :year => 2013, :month => 11}, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_month_array, '14/11/2013', '15/11/2013', 'month'

      # Filtro de 2 meses, usuarios unicos y franja en rango
      connections_between_dates_month_array = [
        { :_id => { :year => 2013, :month => 11}, :count => 1},
        { :_id => { :year => 2013, :month => 12}, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_month_array, '14/11/2013', '14/12/2013', 'month', 'true'

      # Filtro que coja todos los meses, pero la franja este fuera
      xhrRequestConnBetweenDatesAndHours [], '01/01/2013', '01/01/2014', 'month', 'false', '08:45:33', '15:27:03'

      connections_between_dates_month_array = { "error" =>  "Start time is lesser than end time" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_month_array, '01/01/2013', '01/01/2014', 'month', 'false', '08:45:33', '05:27:04'

      connections_between_dates_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_array, '01/01/2013', '01/01/2014', 'month', 'false', '088:5:33', '05:27004'

      # Filtro que coja un mes, pero la franja este fuera
      xhrRequestConnBetweenDatesAndHours [], '14/12/2013', '14/12/2014', 'month', 'false', '07:19:01', '08:45:31'

    end

    it "should return connections filtered by time grouped by day" do
      # Creamos otra conexion mas en Noviembre del 2013 pero a otra hora distinta
      FactoryGirl.create(:connection_at_10_07_on_2013)

      # Filtro que coja todas las conexiones
      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 11, :day => 14 }, :count => 3},
        { :_id => { :year => 2013, :month => 12, :day => 14 }, :count => 1},
        { :_id => { :year => 2014, :month => 1, :day => 01 }, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, 
          '14/11/2013', '01/01/2014', 'day', 'false', '05:27:04', '10:07:59'

      # Filtro que coja solo un dia de noviembre y con un rango que abarque a todas las conexiones en total
      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 11, :day => 14 }, :count => 3}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, '14/11/2013', '14/11/2013', 'day'

      # Filtro que coja solo un dia de noviembre, visitantes unicos y con un rango que abarque sólo las conexiones de ese dia
      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 11, :day => 14 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, 
          '14/11/2013', '14/11/2013', 'day', 'true', '05:27:04', '10:07:59'

      # Filtro que coja solo un dia de noviembre, y con un rango que descarte la conexion de las 10
      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 11, :day => 14 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, 
          '14/11/2013', '14/11/2013', 'day', 'false', '05:27:04', '10:07:58'

      connections_between_dates_array = { "error" =>  "Start time is lesser than end time" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_array, '14/11/2013', '14/11/2013', 'day', 'true', '10:58:00', '05:27:03'

      connections_between_dates_array = { "error" =>  "One hour is invalid. Correct format: HH:MM:SS" }
      xhrRequestConnBetweenDatesAndHours connections_between_dates_array, '01/01/2013', '01/01/2014', 'day', 'false', '088:5:33', '05:27004'

      # Filtro que coja el resto de dias descartando los de noviembre mediante el rango de horas
      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 12, :day => 14 }, :count => 1},
        { :_id => { :year => 2014, :month => 1, :day => 01 }, :count => 1}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, 
          '01/01/2013', '01/01/2014', 'day', 'false', '07:19:00', '08:45:32'

      connections_between_dates_day_array = [
        { :_id => { :year => 2013, :month => 11, :day => 14 }, :count => 2}
      ]
      xhrRequestConnBetweenDatesAndHours connections_between_dates_day_array, 
          '01/01/2013', '01/01/2014', 'day', 'false', '05:27:04', '05:27:04'

      xhrRequestConnBetweenDatesAndHours [], '15/11/2013', '01/01/2014', 'day', 'false', '05:27:04', '05:27:04'

    end

    def xhrRequestConnBetweenDatesAndHours(expected_array, st_date='01/01/2013', end_date='01/01/2014', group_by='year', unique='false', 
      from="00:00:00", to="23:59:59")

      expected = expected_array.to_json
      xhr :get, :connections_between_dates, :start_date => st_date, :end_date => end_date, :unique_visitors => unique, :group_by => group_by, :start_hour => from, :end_hour => to
      expect(response.body).to eql(expected)
    end

  end
end