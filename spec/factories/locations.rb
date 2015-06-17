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
  factory :connection_from_Spain, class: Connection do
    ip '84.20.10.5'
    identd '-'
    userid '-'
    datetime '2014-11-14 05:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 11356
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
    bytes 8766
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 10
    country 'France'
  end

  factory :connection_from_United_States, class: Connection do
    ip '208.65.174.66'
    identd '-'
    userid '-'
    datetime '2015-02-01 03:10:39 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 2567546
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 20
    country 'United States'
  end

	factory :connection_from_China, class: Connection do
    ip '101.124.0.0'
    identd '-'
    userid '-'
    datetime '2015-02-11 10:55:42 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 23978
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 6
    country 'China'
  end

  factory :connection_from_Germany, class: Connection do
    ip '77.246.112.0'
    identd '-'
    userid '-'
    datetime '2015-03-01 09:15:23 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 42890
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 18
    country 'Germany'
  end

  factory :connection_from_Italy, class: Connection do
    ip '84.253.128.0'
    identd '-'
    userid '-'
    datetime '2015-03-25 13:19:14 UTC'
    request 'GET /pepito.ogg HTTP/1.1'
    status 200
    bytes 4537
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 73
    country 'Italy'
  end

  factory :connection_from_Unknown, class: Connection do
    ip '84.20.10.5'
    identd '-'
    userid '-'
    datetime '2015-11-26 05:27:04 UTC'
    request 'GET /cuacfm.mp3 HTTP/1.1'
    status 200
    bytes 11356
    referrer '-'
    user_agent 'iTunes/9.1.1'
    seconds_connected 6
    country ''
  end
  
end