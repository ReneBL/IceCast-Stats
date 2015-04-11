FactoryGirl.define do
  factory :connection_on_2013, class: Connection do
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
  
  factory :connection_on_2014, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_on_2015, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2015-02-08 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_on_Jan_2014, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-01-18 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_on_Feb_2014, class: Connection do
    ip '78.56.19.244'
    identd '-'
    userid '-'
    datetime '2014-02-19 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_on_Mar_2014, class: Connection do
    ip '86.50.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_on_Jan_2015, class: Connection do
    ip '190.46.109.144'
    identd '-'
    userid '-'
    datetime '2015-01-01 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end
  
  factory :connection_with_5_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 5
  end
  
  factory :connection_with_20_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 20
  end
  
  factory :connection_with_30_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 30
  end
  
  factory :connection_with_60_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 60
  end
  
  factory :connection_with_120_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 120
  end
  
end
