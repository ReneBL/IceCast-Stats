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

module DynamicQueryResolver

  def self.initialize query_params
    @qp = query_params
  end

  def self.project_group_parts
    error = nil
    case @qp.group_by
    when "year"
      project = {"$project" => {"year" => {"$year" => "$datetime"}, "datetime" => 1}}
      group = {"$group" => { "_id" => {"year" => "$year"}}}
    when "month"
      project = {"$project" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1}}
      group = {"$group" => {"_id" => {"year" => "$year", "month" => "$month"}}}
    when "day"
      project = {"$project" => {"datetime" => 1}}
      group = {"$group" => { "_id" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"},
        "day" => {"$dayOfMonth" => "$datetime"}}}}
    else
      error = {"error" => "Invalid group by option: try year, month or day"}
    end
    [project, group, error]
  end

  def self.project_ip_decorator project
    project["$project"].merge!({"ip" => 1})
  end

  def self.project_totalSeconds_decorator project
    project["$project"].merge!({"totalSeconds" => {"$add" => [{"$multiply" => [{"$hour" =>"$datetime"}, 3600]}, {"$multiply" => [{"$minute" => "$datetime"}, 60]},
           {"$second" => "$datetime"}]}})
  end

  def self.group_by_distinct_visitors_decorator group
    group["$group"].merge!({"ips" => {"$addToSet" => "$ip"}})
  end

  def self.distinct_visitors_count
    unwind = {"$unwind" => "$ips"}
    group = {"$group" => {"_id" => "$_id"}}
    [unwind, group]
  end

  def self.match_part match
    # El filtro match ya estará inicializado, bien a vacio o bien al filtro correspondiente si la request llega
      # con un source metido en la session
    match["$match"].merge!({"datetime" => {"$gte" => @qp.start_date, "$lte" => @qp.end_date}})
    match
  end

  def self.set_unique_if_exists project, group_by, group_decorator
  	if is_unique
    	# Si es así, decoramos project y group by para que agrupe por IP's y haga count gracias a unwind y un segundo group
      project_ip_decorator project
      group_by_distinct_visitors_decorator group_by
      unwind, group = distinct_visitors_count
      # Si buscamos por visitantes únicos, necesitamos decorar la parte group que genera el distinct_visitors_count
      gd = GroupDecorator.new group_decorator
      gd.decorate group
      return [unwind, group]
    else
      # Si no es por visitantes únicos, decoraremos la parte group_by que ha venido dada como parámetro
    	gd = GroupDecorator.new group_decorator
      gd.decorate group_by
      return [nil, nil]
    end
  end

  def self.hours_filter
    hours_matcher = {"$match" => {}}
    if (@qp.has_hour_filters?)
      if (@qp.max_hour_seconds < @qp.min_hour_seconds)
        # Si se da el caso de que start hour es anterior a end hour en cuanto a segundos, tenemos que ponerlo como primer parametro
        # en el match, por que no tendria sentido comparar => value > MAX && value < MIN
        hours_matcher["$match"].merge!({"totalSeconds" => {"$gte" => @qp.max_hour_seconds, "$lte" => @qp.min_hour_seconds}})
      else
        hours_matcher["$match"].merge!({"totalSeconds" => {"$gte" => @qp.min_hour_seconds, "$lte" => @qp.max_hour_seconds}})
      end
    end
    hours_matcher
  end

  def self.is_unique
    @qp.unique
  end

  def self.skip_part skip
    {"$skip" => skip}
  end

  def self.limit_part limit
    {"$limit" => limit}
  end

end
