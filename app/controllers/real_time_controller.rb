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

class RealTimeController < ApplicationController

	def last_connections
		date_now = DateTime.evolve(DateTime.now.change(sec: 0))
		filters = []
		hour_interval = get_hour_interval
		match = {"$match" => {"datetime" => {"$gte" => (date_now - hour_interval.hours), "$lte" => date_now}}}
		project = {"$project" => {"datetime" => 1, "listeners" => 1}}
		group_by = {"$group" => {"_id" => {"datetime" => "$datetime", "listeners" => "$listeners"}}}
		sort = {"$sort" => {"_id" => 1}}
		filters << match << project << group_by << sort
		result = ConnectionRealTime.collection.aggregate(filters)
		render :json => result
  end

  private

  def get_hour_interval
  	config = YAML.load_file('config/parser_rt_config.yml')
  	config["real_time_hour_range"]
  end

end