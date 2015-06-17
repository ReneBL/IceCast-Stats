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

module RangesHelper

	@@MIN = 5
	@@MAX = 120

	def self.min_value
		@@MIN
	end

	def self.max_value
		@@MAX
	end

	def self.ranges_resolver min, max, group
 		group["$group"].merge!({"_id"=> {"$cond"=> [{"$lte"=> ["$seconds_connected", min] },"A: <= " + min.to_s,{"$cond"=> [{"$and"=> [{"$gt"=> ["$seconds_connected", min] },{"$lte"=> ["$seconds_connected", max] }]},"B: " + min.to_s + "-" + max.to_s, {"$cond"=> [{"$gt"=> ["$seconds_connected", max ] },"C: > " + max.to_s, "null"]}]}]}})
 	end

end
