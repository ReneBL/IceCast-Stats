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
