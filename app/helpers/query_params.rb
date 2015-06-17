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

class QueryParams
	attr_reader :group_by, :unique, :start_date, :end_date, :start_hour, :end_hour

	def initialize (group_by, unique, start_date, end_date, start_hour, end_hour)
		@group_by = group_by
		@unique = unique
		@start_date = start_date
		@end_date = end_date
		@start_hour = start_hour
		@end_hour = end_hour
	end

	def has_hour_filters?
		(@start_hour != nil) && (@end_hour != nil)
	end

	def min_hour_seconds
		hour_seconds @start_hour
	end

	def max_hour_seconds
		hour_seconds @end_hour
	end

	def hour_seconds hour
		h, m, s = hour.split(":")
		(h.to_i * 3600) + (m.to_i * 60) + s.to_i
	end

end
