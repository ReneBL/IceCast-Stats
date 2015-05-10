class RankingController < StatsController
	before_action :check_search_indexes

	def country_ranking
		return if (@error != nil)
		project = {"$project" => {"datetime" => 1, "seconds_connected" => 1, "country" => 1, "bytes" => 1}}
		group_by = {"$group" => {"_id" => "$country"}}
		qb = QueryBuilder.new
    	qb.add_project project
    	qb.add_match @match
    	qb.add_group_by group_by
    	# Creamos todos los decoradores del group y los encapsulamos en un Composite
    	group_decorator = CompositeGroupDecorator.new
    	group_decorator.add(CountGroupDecorator.new "listeners")
    	group_decorator.add(TotalBytesGroupDecorator.new "bytes")
    	group_decorator.add(TotalSecondsGroupDecorator.new "time") 
    	qb.add_group_decorator group_decorator
    	# Ordenamos por distinto criterio y campos
    	sort = SortDecorator.new
    	sort.add "listeners", SortDecorator::DESC
    	sort.add "bytes", SortDecorator::DESC
    	sort.add "time", SortDecorator::DESC
    	# Lo añadimos al Builder
    	qb.add_sort sort
    	qb.add_pagination @start_index, @count if (@start_index != nil && @count != nil)
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	render :json => result
	end

	private

	def check_search_indexes
		start_index = params[:start_index]
		count = params[:count]
		error = nil
		if (start_index == nil && count == nil)
			@start_index = nil
			@count = nil
			@error = nil
			return
		elsif (start_index.to_i < 0 || count.to_i < 0)
			error = {"error" => "Not valid indexes"}
			render :json => error.to_json
		end
		@start_index = start_index.to_i
		@count = count.to_i
		@error = error
	end

end