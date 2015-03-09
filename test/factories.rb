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
end