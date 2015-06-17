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
  factory :connection_with_none_referrer, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-11-14 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 6
	referrer '-'
	user_agent 'iTunes/9.1.1'
	seconds_connected 5
  end

  factory :connection_with_cuacfm_directo, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-11-14 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 10
	referrer 'http://cuacfm.org/directo'
	user_agent 'iTunes/9.1.1'
	seconds_connected 10
  end

  factory :connection_with_cuacfm_directo2, class: Connection do
	ip '192.20.10.70'
	identd '-'
	userid '-'
	datetime '2014-11-11 01:11:44 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 18
	referrer 'http://cuacfm.org/directo'
	user_agent 'iTunes/9.1.1'
	seconds_connected 56
  end

  factory :connection_with_url_2, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-12-10 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 15
	referrer 'http://url2.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 20
  end

  factory :connection_with_url_3, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-12-16 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 8
	referrer 'http://url3.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 16
  end

  factory :connection_with_url_4, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-12-23 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 13
	referrer 'http://url4.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 25
  end

  factory :connection_with_url_5, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-12-30 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 11
	referrer 'http://url5.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 30
  end

  factory :connection_with_url_6, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2014-12-31 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 18
	referrer 'http://url6.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 28
  end

  factory :connection_with_url_7, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-01-01 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 19
	referrer 'http://url7.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 21
  end

  factory :connection_with_url_8, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-01-04 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 24
	referrer 'http://url8.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 46
  end

  factory :connection_with_url_9, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-01-14 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 33
	referrer 'http://url9.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 50
  end

  factory :connection_with_url_10, class: Connection do
	ip '84.20.10.5'
	identd '-'
	userid '-'
	datetime '2015-01-30 05:27:04 UTC'
	request 'GET /cuacfm.mp3 HTTP/1.1'
	status 200
	bytes 12
	referrer 'http://url10.com'
	user_agent 'iTunes/9.1.1'
	seconds_connected 90
  end
  
end