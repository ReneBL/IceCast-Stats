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

class LocationsController < StatsController
  before_action :initialize_project, except: [:get_countries]
	before_action :check_country_param, only: [:regions, :regions_time, :cities, :cities_time, :get_regions]
  before_action :check_regions_param, only: [:cities, :cities_time]
	skip_before_action :generate_query_params, only: [:get_countries, :get_regions]

	def countries_time
    @project["$project"].merge!({"seconds_connected" => 1}).merge!(LocationsHelper.project_countries)
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count", "$seconds_connected")}
    do_request stages
	end

	def countries
    @project["$project"].merge!(LocationsHelper.project_countries)
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count")}
    do_request stages
	end

  def regions
  	@match["$match"].merge!({"country" => @country})
  	@project["$project"].merge!(LocationsHelper.project_regions)
    group_by = {"$group" => {"_id" => {"region" => "$region"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count")}
    do_request stages
  end

  def regions_time
  	@match["$match"].merge!({"country" => @country})
  	@project["$project"].merge!({"seconds_connected" => 1}).merge!(LocationsHelper.project_regions)
    group_by = {"$group" => {"_id" => {"region" => "$region"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count", "$seconds_connected")}
    do_request stages
  end

  def cities
    @match["$match"].merge!({"country" => @country, "region" => @region})
    @project["$project"].merge!(LocationsHelper.project_cities)
    group_by = {"$group" => {"_id" => {"city" => "$city"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count")}
    do_request stages
  end

  def cities_time
    @match["$match"].merge!({"country" => @country, "region" => @region})
    @project["$project"].merge!({"seconds_connected" => 1}).merge!(LocationsHelper.project_cities)
    group_by = {"$group" => {"_id" => {"city" => "$city"}}}
    stages = {"project" => @project, "match" => @match, "group_by" => group_by, 
      "group_decorator" => (CountGroupDecorator.new "count", "$seconds_connected")}
    do_request stages
  end

  def get_countries
  	temp = Connection.all.distinct(:country)
  	# Borramos ĺas cadenas vacías
  	result = delete_empty temp
  	render :json => result.sort
  end

  def get_regions
    temp = Connection.where(:country => @country).distinct(:region)
    result = delete_empty temp
    render :json => result.sort
  end

	private

    def initialize_project
      @project = {"$project" => {}}
    end

    def do_request stages
      qb = QueryBuilder.new
      qb.add_project stages["project"]
      qb.add_match stages["match"]
      qb.add_group_by stages["group_by"]
      qb.add_group_decorator stages["group_decorator"]
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	render :json => result
    end

    def delete_empty result
      result.delete_if {|res| res.empty?}
    end

    def check_country_param
    	if (params[:country].empty? || (params[:country].eql? " ") || params[:country].nil?)
    		render :json => {"error" => "Invalid country"}
    		return false
    	else
    		@country = params[:country]
    	end
    end

    def check_regions_param
      if (params[:region].empty? || (params[:region].eql? " ") || params[:region].nil?)
        render :json => {"error" => "Invalid region"}
        return false
      else
        @region = params[:region]
      end
    end
end