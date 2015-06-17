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

	factory :connection_24_hours_1_minute_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 24.hours - 1.minute).change(sec: 0))
		listeners 4
	end

	factory :connection_24_hours_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 24.hours).change(sec: 0))
		listeners 6
	end

	factory :connection_2_hours_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 2.hours).change(sec: 0))
		listeners 2
	end

	factory :connection_1_second_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 1.second).change(sec: 0))
		listeners 8
	end

	factory :connection_1_second_above, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now + 1.minute).change(sec: 0))
		listeners 10
	end

end