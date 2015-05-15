FactoryGirl.define do
  factory :connection_from_Galicia, class: Connection do
    ip '178.60.40.160'
    identd '-'
    userid '-'
    datetime '2014-07-17 00:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 110
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 10
    country 'Spain'
    region 'Galicia'
    country_code 'ES'
  end

  factory :connection_from_Extremadura, class: Connection do
    ip '176.10.70.160'
    identd '-'
    userid '-'
    datetime '2014-12-01 09:40:01 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 870
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 15
    country 'Spain'
    region 'Extremadura'
    country_code 'ES'
  end

  factory :connection_from_Cataluña, class: Connection do
    ip '194.224.90.19'
    identd '-'
    userid '-'
    datetime '2015-02-01 03:10:39 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 2567546
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 20
    country 'Spain'
    region 'Cataluña'
    country_code 'ES'
  end

  factory :connection_from_Madrid, class: Connection do
    ip '62.32.144.39'
    identd '-'
    userid '-'
    datetime '2015-02-11 17:55:42 UTC'
    request 'GET /cuacfm.aac HTTP/1.1'
    status 200
    bytes 23
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 8
    country 'Spain'
    region 'Madrid'
    country_code 'ES'
  end

  factory :connection_from_New_Jersey, class: Connection do
    ip '62.32.144.39'
    identd '-'
    userid '-'
    datetime '2015-02-10 13:25:41 UTC'
    request 'GET /cuacfm.aac HTTP/1.1'
    status 200
    bytes 23
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 8
    country 'United States'
    region 'New Jersey'
    country_code 'US'
  end
end