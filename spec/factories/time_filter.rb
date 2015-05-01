FactoryGirl.define do
  factory :connection_at_5_27_on_2013, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2013-11-14 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

  factory :connection_at_10_07_on_2013, class: Connection do
    ip '78.50.19.144'
    identd '-'
    userid '-'
    datetime '2013-11-14 10:07:59 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_at_7_19_on_2013, class: Connection do
    ip '78.50.19.144'
    identd '-'
    userid '-'
    datetime '2013-12-14 07:19:00 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

  factory :connection_at_8_45_on_2014, class: Connection do
    ip '192.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-01-01 08:45:32 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
end