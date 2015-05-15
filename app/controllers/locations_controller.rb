class LocationsController < StatsController
	before_action :check_country_param, only: [:regions]
	skip_before_action :generate_query_params, only: [:get_countries]

	def countries_time
    project = {"$project" => {"country" => 1, "seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator CountGroupDecorator.new "count", "$seconds_connected"
    do_request qb
	end

	def countries
    project = {"$project" => {"country" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator CountGroupDecorator.new "count"
    do_request qb
	end

  def regions
  	@match["$match"].merge!({"country" => @country})
  	project = {"$project" => {"region" => 1}}
    group_by = {"$group" => {"_id" => {"region" => "$region"}}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    group_decorator = CompositeGroupDecorator.new
    group_decorator.add CountGroupDecorator.new "count"
    qb.add_group_decorator group_decorator
    do_request qb
  end

  def get_countries
  	result = Connection.all.order_by(:country.asc).distinct(:country)
  	render :json => result
  end

	private

    def do_request qb
    	filters = qb.construct
    	result = Connection.collection.aggregate(filters)
    	render :json => result
    end

    def check_country_param
    	if (params[:country].empty? || (params[:country].eql? " "))
    		render :json => {"error" => "Invalid country"}
    		return false
    	else
    		@country = params[:country]
    	end
    end
end