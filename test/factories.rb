FactoryGirl.define do
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
    seconds_connected 3
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
    seconds_connected 1
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
    seconds_connected 3
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
