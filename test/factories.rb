FactoryGirl.define do
	factory :folk_in_trio_monday, class: Program do
		name 'Folk in trio'
		seconds_listened 600 # 10 minutos
	end

	factory :el_rinconcito_monday, class: Program do
		name 'El Rinconcito'
		seconds_listened 3000 # 50 minutos
	end

	factory :spoiler_tuesday, class: Program do
		name 'Spoiler'
		seconds_listened 2400 # 40 minutos
	end

	factory :sin_etiquetas_friday, class: Program do
		name 'Sin Etiquetas'
		seconds_listened 2400 # 40 minutos
	end

	factory :radiocassette_friday, class: Program do
		name 'Radiocassette'
		seconds_listened 3600 # 60 minutos
	end

	factory :informativos_friday, class: Program do
		name 'Informativos'
		seconds_listened 3000 # 50 minutos
	end

	factory :friday_listening_Informativos_Radiocassette_Sin_Etiq, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-05-15 07:40:00 UTC'
    request 'GET /cuacfm.aac HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 9000
    programs {[FactoryGirl.build(:informativos_friday), FactoryGirl.build(:radiocassette_friday), FactoryGirl.build(:sin_etiquetas_friday)]}
  end

	factory :monday_listening_FolkInTrio_ElRinconcito, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-04-05 23:10:00 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3600 # Una hora
    programs {[FactoryGirl.build(:el_rinconcito_monday), FactoryGirl.build(:folk_in_trio_monday)]}
  end

  factory :tuesday_listening_Spoiler, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-04-21 20:40:00 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 2400 # 40 minutos
    programs {[FactoryGirl.build(:spoiler_tuesday)]}
  end

  # Esta conexión no tendrá info de programas, está fuera de la programación
  factory :connection_out_of_schedule, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-03-31 08:10:00 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 2400 # 40 minutos
    programs {[]}
  end

  factory :not_scheduled_source, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-04-20 23:10:00 UTC'
    request 'GET /filispin.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 600
    programs {[]}
  end

  factory :connection_minor_than_5_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

  factory :connection_ok, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 5
  end
  
  factory :connection2, class: Connection do
    ip '208.94.246.226'
    identd '-'
    userid '-'
    datetime '2015-01-19 15:03:31 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.0'
    status 200
    bytes 68999
    referrer '-'
    user_agent 'Winamp 2.81'
    seconds_connected 9
  end
  
  factory :connection3, class: Connection do
    ip '81.45.53.99'
    identd '-'
    userid '-'
    datetime '2015-01-19 15:08:41 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 689633
    referrer '-'
    user_agent 'Dalvik/1.6.0 (Linux; U; Android 4.2.2; GT-S7580 Build/JDQ39)'
    seconds_connected 79
  end
  
  factory :bad_status_connection, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 800
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 13
  end
  
  factory :connection_with_seconds_and_bytes_lower_0, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 404
    bytes -1
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected -1
  end
  
  factory :blank_connection, class: Connection do
    ip ''
    identd ''
    userid ''
    datetime ''
    request ''
    status ''
    bytes ''
    referrer ''
    user_agent ''
    seconds_connected '' 
  end
end
