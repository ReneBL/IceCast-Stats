FactoryGirl.define do
  factory :connection_from_Spain, class: Connection do
    ip '84.20.10.5'
    identd '-'
    userid '-'
    datetime '2014-11-14 05:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
    country 'Spain'
  end

  factory :connection_from_France, class: Connection do
    ip '62.233.32.40'
    identd '-'
    userid '-'
    datetime '2014-12-01 09:40:01 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 10
    country 'France'
  end

  factory :connection_from_United_States, class: Connection do
    ip '208.65.174.66'
    identd '-'
    userid '-'
    datetime '2015-02-01 11:35:59 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 20
    country 'United States'
  end
  
end