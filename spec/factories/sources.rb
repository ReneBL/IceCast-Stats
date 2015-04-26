FactoryGirl.define do
  factory :source_cuacfm_128k, class: Connection do
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

  factory :source_cuacfm_november, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2013-11-14 05:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

  factory :source_cuacfm_december, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2013-12-14 05:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

  factory :source_pepito, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2013-11-14 05:27:04 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 3
  end

end
