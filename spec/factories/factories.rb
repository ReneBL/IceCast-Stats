=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

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
  
  factory :connection_with_4_seconds, class: Connection do
    ip '78.86.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-25 05:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 4
  end
  
  factory :connection_with_5_seconds, class: Connection do
    ip '78.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-03-27 06:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 5
  end

  factory :connection_with_8_seconds, class: Connection do
    ip '78.46.30.144'
    identd '-'
    userid '-'
    datetime '2014-03-27 08:27:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 8
  end

  factory :connection_with_20_seconds, class: Connection do
    ip '78.50.19.144'
    identd '-'
    userid '-'
    datetime '2014-04-05 06:30:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 20
  end
  
  factory :connection_with_30_seconds, class: Connection do
    ip '78.46.20.144'
    identd '-'
    userid '-'
    datetime '2014-04-15 10:00:14 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 30
  end
  
  factory :connection_with_60_seconds, class: Connection do
    ip '90.46.19.144'
    identd '-'
    userid '-'
    datetime '2014-10-09 11:17:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 60
  end
  
  factory :connection_with_120_seconds, class: Connection do
    ip '78.46.19.154'
    identd '-'
    userid '-'
    datetime '2014-11-11 04:50:04 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 120
  end

  factory :connection_with_200_seconds, class: Connection do
    ip '78.76.19.154'
    identd '-'
    userid '-'
    datetime '2015-01-01 12:47:03 UTC'
    request 'GET /cuacfm-128k.mp3 HTTP/1.1'
    status 200
    bytes 115396
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 200
  end
  
end
