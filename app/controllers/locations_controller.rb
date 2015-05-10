class LocationsController < StatsController

	def countries_time
    project = {"$project" => {"country" => 1, "seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator TotalSecondsGroupDecorator.new "count"
    filters = qb.construct
    result = Connection.collection.aggregate(filters)
    render :json => result
	end

	def countries
    project = {"$project" => {"country" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator CountGroupDecorator.new "count"
    filters = qb.construct
    result = Connection.collection.aggregate(filters)
    render :json => result
	end

	private

	def common_process_countries filters, project, group_by
		
	end

end