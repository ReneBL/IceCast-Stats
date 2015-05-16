class RankingController < StatsController
	before_action :check_search_indexes

	@@UNKNOWN = "Unknown"

	def country_ranking
		project = @common_project
		project["$project"].merge!(@project_countries)
		group_by = {"$group" => {"_id" => "$country"}}
		common_ranking_process project, group_by
	end

	def region_ranking
		project = @common_project
		project["$project"].merge!(@project_regions).merge!(@project_countries)
		group_by = {"$group" => {"_id" => {"region" => "$region", "country" => "$country"}}}
		common_ranking_process project, group_by
	end

	private

	def check_search_indexes
		@common_project = {"$project" => {"datetime" => 1, "seconds_connected" => 1, "bytes" => 1}}
		@project_countries = {"country" => {"$cond" => [{"$ne" => ["$country", ""]}, "$country", @@UNKNOWN]}}
		@project_regions = {"region" => {"$cond" => [{"$ne" => ["$region", ""]}, "$region", @@UNKNOWN]}}
		start_index = params[:start_index]
		count = params[:count]
		start_nil = (start_index.nil?)
		count_nil = (count.nil?)
		if (start_nil && count_nil)
			@start_index = nil
			@count = nil
			return
		elsif ((start_index.to_i < 0 || count.to_i <= 0) || (start_nil && !count_nil) || (count_nil && !start_nil))
			error = {"error" => "Not valid indexes"}
			render :json => error.to_json
			return false
		end
		@start_index = start_index.to_i
		@count = count.to_i
	end

	def common_ranking_process project, group_by
		qb = QueryBuilder.new
    	qb.add_project project
    	qb.add_match @match
    	qb.add_group_by group_by
    	# Creamos todos los decoradores del group y los encapsulamos en un Composite
    	group_decorator = CompositeGroupDecorator.new
    	group_decorator.add(CountGroupDecorator.new "listeners")
    	group_decorator.add(CountGroupDecorator.new "bytes", "$bytes")
    	group_decorator.add(CountGroupDecorator.new "time", "$seconds_connected") 
    	qb.add_group_decorator group_decorator
    	# Ordenamos por distinto criterio y campos
    	sort = SortDecorator.new
    	sort.add "listeners", SortDecorator::DESC
    	sort.add "bytes", SortDecorator::DESC
    	sort.add "time", SortDecorator::DESC
    	sort.add "_id", SortDecorator::ASC
    	# Lo añadimos al Builder
    	qb.add_sort sort
    	qb.add_pagination @start_index, (@count + 1) if (!@start_index.nil? && !@count.nil?)
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	adapt_paginate! result if (!@start_index.nil? && !@count.nil? && result.count > 0)
    	render :json => result
	end

	def adapt_paginate! result
		if (result.count == @count + 1)
			result.delete_at(result.count - 1)
			result << {"hasMore" => true}
		else
			result << {"hasMore" => false}
		end
	end

end