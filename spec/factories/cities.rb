FactoryGirl.define do
  factory :connection_from_Coruña, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-11-14 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 40
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 20
	country 'Spain'
	region 'Galicia'
	city 'A Coruña'
  end

  factory :connection_from_Laracha, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-11-16 04:57:09 UTC'
	request 'GET /cuacfm.aac HTTP/1.1'
	status 200
	bytes 25
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 10
	country 'Spain'
	region 'Galicia'
	city 'Laracha'
  end

  factory :connection_from_Barcelona, class: Connection do
	ip '62.233.32.40'
	identd '-'
	userid '-'
	datetime '2014-12-01 09:40:01 UTC'
	request 'GET /cuacfm-128k.mp3 HTTP/1.1'
	status 200
	bytes 10
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 5
	country 'Spain'
	region 'Cataluña'
	city 'Barcelona'
  end

  factory :connection_from_Valencia, class: Connection do
	ip '208.65.174.66'
	identd '-'
	userid '-'
	datetime '2015-02-01 03:10:39 UTC'
	request 'GET /pepito.ogg HTTP/1.1'
	status 200
	bytes 20
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 10
	country 'Spain'
	region 'Comunidad Valenciana'
	city 'Valencia'
  end

	factory :connection_from_Bilbao, class: Connection do
	ip '101.124.0.0'
	identd '-'
	userid '-'
	datetime '2015-02-11 10:55:42 UTC'
	request 'GET /pepito.ogg HTTP/1.1'
	status 200
	bytes 30
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 15
	country 'Spain'
	region 'País Vasco'
	city 'Bilbao'
  end

  factory :connection_from_Unknown_all, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-11-26 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 11356
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 16
	country ''
	region ''
	city ''
  end

  factory :connection_from_Unknown_city_region, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-11-27 08:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 345
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 6
	country 'Spain'
	region ''
	city ''
  end

  factory :connection_from_Unknown_country_region, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-11-28 12:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 657
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 8
	country ''
	region ''
	city 'BlaBla'
  end
  
end