class RankingController < StatsController
	before_action :initialize_common_project_stage
	before_action :check_search_indexes, except: [:top10_links_ranking]

	def country_ranking
		project = @common_project
		project["$project"].merge!(LocationsHelper.project_countries)
		group_by = {"$group" => {"_id" => "$country"}}
		qb = common_ranking_process project, group_by
		render :json => (pagination qb)
	end

	def region_ranking
		project = @common_project
		project["$project"].merge!(LocationsHelper.project_regions).merge!(LocationsHelper.project_countries)
		group_by = {"$group" => {"_id" => {"region" => "$region", "country" => "$country"}}}
		qb = common_ranking_process project, group_by
		render :json => (pagination qb)
	end

	def city_ranking
		project = @common_project
		project["$project"].merge!(LocationsHelper.project_regions).merge!(LocationsHelper.project_countries).merge!(LocationsHelper.project_cities)
		group_by = {"$group" => {"_id" => {"city" => "$city", "region" => "$region", "country" => "$country"}}}
		qb = common_ranking_process project, group_by
		render :json => (pagination qb)
	end

	def user_agent_ranking
		project = @common_project
		project["$project"].merge!({"user_agent" => 1})
		group_by = {"$group" => {"_id" => "$user_agent"}}
		@match["$match"].merge!({"user_agent" => {"$ne" => "-"}})
		qb = common_ranking_process project, group_by
		render :json => (pagination qb)
	end

	def top_links_ranking
		project = @common_project
		project["$project"].merge!({"referrer" => 1})
		group_by = {"$group" => {"_id" => "$referrer"}}
		@match["$match"].merge!({"referrer" => {"$ne" => "-"}})
		qb = common_ranking_process project, group_by
		qb.add_pagination START_INDEX, LINKS_RANKING_COUNT
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	result.delete_if {|link| link["_id"].eql? "-"}
    	render :json => result
	end

	private

	def initialize_common_project_stage
		@common_project = {"$project" => {"datetime" => 1, "seconds_connected" => 1, "bytes" => 1}}
	end

	def check_search_indexes
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
    	qb
	end

	def pagination qb
		qb.add_pagination @start_index, (@count + 1) if (!@start_index.nil? && !@count.nil?)
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	adapt_paginate! result if (!@start_index.nil? && !@count.nil? && result.count > 0)
    	result
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