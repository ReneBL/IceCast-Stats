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

    @all_non_unique = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 3000.0, :time => 3000},
        {:_id => "Folk in trio", :listeners => 1, :avg => 600.0, :time => 600},
        {:_id => "Informativos", :listeners => 2, :avg => 3000.0, :time => 6000},
        {:_id => "Radiocassette", :listeners => 2, :avg => 3600.0, :time => 7200},
        {:_id => "Sin Etiquetas", :listeners => 2, :avg => 2400.0, :time => 4800},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
    ]

    @friday_connections_filtered = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 3000.0, :time => 3000},
        {:_id => "Folk in trio", :listeners => 1, :avg => 600.0, :time => 600},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
    ]

    @friday_connections_filtered_without_spoiler = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 3000.0, :time => 3000},
        {:_id => "Folk in trio", :listeners => 1, :avg => 600.0, :time => 600}
    ]

    @friday_connections_filtered_unique = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Folk in trio", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
    ]

    @friday_connections_filtered_unique_without_spoiler = [
        {:_id => "El Rinconcito", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Folk in trio", :listeners => 1, :avg => 0.0, :time => 0}
    ]

    @monday_connections_filtered = [
        {:_id => "Informativos", :listeners => 2, :avg => 3000.0, :time => 6000},
        {:_id => "Radiocassette", :listeners => 2, :avg => 3600.0, :time => 7200},
        {:_id => "Sin Etiquetas", :listeners => 2, :avg => 2400.0, :time => 4800},
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
    ]

    @monday_connections_filtered_unique = [
        {:_id => "Informativos", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Radiocassette", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Sin Etiquetas", :listeners => 1, :avg => 0.0, :time => 0},
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
    ]

    @none_connections = []

    @monday_friday_filtered = [
        {:_id => "Spoiler", :listeners => 3, :avg => 2400.0, :time => 7200}
    ]

    @monday_friday_filtered_unique = [
        {:_id => "Spoiler", :listeners => 1, :avg => 0.0, :time => 0}
    ]
  end

  describe "when access to program grouped connections by time strip" do

    it "should return programs grouped and filtered by time" do
      xhrRequestPrograms @all_non_unique

      # Descartamos las conexiones del viernes
  		xhrRequestPrograms @friday_connections_filtered, '07:40:01'

      # Descartamos las conexiones del viernes y agrupamos por visitantes
      xhrRequestPrograms @friday_connections_filtered_unique, '07:40:01', '23:59:59', 'true'

      # Descartamos las conexiones del lunes
      xhrRequestPrograms @monday_connections_filtered, '07:40:00', '23:09:59'

      # Descartamos las conexiones del lunes y agrupamos por visitantes
      xhrRequestPrograms @monday_connections_filtered_unique, '07:40:00', '23:09:59', 'true'

      # Descartamos todas las conexiones
      xhrRequestPrograms @none_connections, '23:10:01', '23:59:59'

      # Descartamos todas las conexiones y agrupamos por visitantes
      xhrRequestPrograms @none_connections, '23:10:01', '23:59:59', 'true'
    end

    it "should return programs filtered by time and date" do
      # Filtramos las conexiones del viernes por fecha fin
      xhrRequestPrograms @friday_connections_filtered_without_spoiler, '23:10:00', '23:59:59', 'false', '31/03/2015', '14/05/2015'

      # Filtramos las conexiones del viernes por fecha fin agrupando por visitante
      xhrRequestPrograms @friday_connections_filtered_unique_without_spoiler, '23:10:00', '23:59:59', 'true', '31/03/2015', '14/05/2015'

      # Filtramos las conexiones del lunes por fecha inicio teniendo rango de horas amplio
      xhrRequestPrograms @monday_connections_filtered, '00:00:00', '23:59:59', 'false', '06/04/2015', '15/05/2015'

      # Filtramos las conexiones del lunes por fecha inicio teniendo rango de horas amplio agrupando por visitante
      xhrRequestPrograms @monday_connections_filtered_unique, '00:00:00', '23:59:59', 'true', '06/04/2015', '15/05/2015'

      # Filtramos viernes
      xhrRequestPrograms @monday_friday_filtered, '20:40:00', '23:09:59'

      # Filtramos viernes y lunes agrupando por visitantes
      xhrRequestPrograms @monday_friday_filtered_unique, '20:40:00', '20:40:00', 'true'

      # Filtramos todo
      xhrRequestPrograms @none_connections, '23:10:01', '23:59:59'
    end

    def xhrRequestPrograms(expected_array, from="00:00:00", to="23:59:59", unique='false', 
        st_date='31/03/2015', end_date='15/05/2015')

      expected = expected_array.to_json
      xhr :get, :programs, :start_date => st_date, :end_date => end_date, :unique_visitors => unique,
        :start_hour => from, :end_hour => to, :format => :json
      expect(response.body).to eql(expected)
    end
  end
end