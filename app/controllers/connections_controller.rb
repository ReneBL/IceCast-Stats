class ConnectionsController < StatsController
  
  def index
  end

  def total_seconds
    project = {"$project" => {"seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => "total"}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator TotalSecondsGroupDecorator.new
    filters = qb.construct
    result = Connection.collection.aggregate(filters)
    render :json => result
  end

  def avg_seconds
    project = {"$project" => {"seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => "avg"}}
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator AvgSecondsGroupDecorator.new
    filters = qb.construct
    result = Connection.collection.aggregate(filters)
    render :json => result
  end
  
  def ranges
    # Obtenemos los parametros min y max
    min, max, error = ranges_params
    # Si ha habido un error, salimos de la ejecución del método
    return if (error != nil)
    # Inicializamos project y group
    project = {"$project" => {"seconds_connected" => 1}}
    group_by = {"$group" => {}}
    RangesHelper.ranges_resolver min, max, group_by
    qb = QueryBuilder.new
    qb.add_project project
    qb.add_match @match
    qb.add_group_by group_by
    qb.add_group_decorator CountGroupDecorator.new
    filters = qb.construct
    result = Connection.collection.aggregate(filters)
    render :json => result
  end

  def total_seconds_grouped
  	project, group_by, error = DynamicQueryResolver.project_group_parts
    if error == nil
      if project != nil && group_by != nil
      	project["$project"].merge!({"seconds_connected" => 1})
      	qb = QueryBuilder.new
      	qb.add_project project
      	qb.add_match @match
      	qb.add_group_by group_by
      	qb.add_group_decorator TotalSecondsGroupDecorator.new
        filters = qb.construct
        result = Connection.collection.aggregate(filters)
        render :json => result
      end
    else
      render :json => error.to_json
    end
  end
  
  def connections_between_dates
    project, group_by, error = DynamicQueryResolver.project_group_parts
    if error == nil
      if project != nil && group_by != nil
      	qb = QueryBuilder.new
      	qb.add_project project
      	qb.add_match @match
      	qb.add_group_by group_by
      	qb.add_group_decorator CountGroupDecorator.new
        filters = qb.construct
        result = Connection.collection.aggregate(filters)
        render :json => result
      end
    else
      render :json => error.to_json
    end
  end
  
  private

  def ranges_params
    min = params[:min]
    max = params[:max]
    valid = ((min != nil) && (max != nil) && (min.to_i <= max.to_i) && (min.to_i >= 0) && (max.to_i >= 0))
    unless !valid
      return [min.to_i, max.to_i, nil]
    end
    error = { "error" => "Rango no válido (min <= max | min && max not null | min && max >= 0)" }
    render :json => error.to_json
    return [min.to_i, max.to_i, error]
  end

  def seconds_filter_aggregator filters

  end
  
end