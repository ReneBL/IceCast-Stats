module DynamicQueryResolver

  def self.initialize query_params
    @qp = query_params
  end

  def self.project_group_parts
    error = nil
    case @qp.group_by
    when "year"   
      if @qp.unique
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "datetime" => 1, "ip" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year"}, "ips" => {"$addToSet" => "$ip"}}}
      else
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "datetime" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year"}, "count" => {"$sum" => 1}}}
      end
    when "month"
      if @qp.unique
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1, "ip" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year", "month" => "$month"}, "ips" => {"$addToSet" => "$ip"}}}
      else
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1}}
        group = {"$group" => {"_id" => {"year" => "$year", "month" => "$month"}, "count" => {"$sum" => 1}}}
      end
    when "day"
      if @qp.unique
        project = {"$project" => {"datetime" => 1, "ip" => 1}}
        group = {"$group" => { "_id" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"},
        "day" => {"$dayOfMonth" => "$datetime"}}, "ips" => {"$addToSet" => "$ip"}}}
      else
        project = {"$project" => {"datetime" => 1}}
        group = {"$group" => { "_id" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"},
        "day" => {"$dayOfMonth" => "$datetime"}}, "count" => {"$sum" => 1}}}
      end
    else
      error = {"error" => "Invalid group by option: try year, month or day"}
    end
    if ((error == nil) && (@qp.has_hour_filters?))
      project["$project"].merge!({"totalSeconds" => {"$add" => [{"$multiply" => [{"$hour" =>"$datetime"}, 3600]}, {"$multiply" => [{"$minute" => "$datetime"}, 60]},
           {"$second" => "$datetime"}]}})
    end
    [project, group, error]
  end
  
  def self.distinct_visitors_count        
    unwind = {"$unwind" => "$ips"}
    group = {"$group" => {"_id" => "$_id", "count" => {"$sum" => 1}}}
    [unwind, group]
  end

  def self.match_part match
    # El filtro match ya estará inicializado, bien a vacio o bien al filtro correspondiente si la request llega
      # con un source metido en la session
    match["$match"].merge!({"datetime" => {"$gte" => @qp.start_date, "$lte" => @qp.end_date}})
    match
  end

  def self.sort_part
    sort = {"$sort" => {"_id" => 1}}
    sort
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

  # def self.get_filters
  #   [project, group, error] = self.project_group_parts
  #   if error == nil
  #     if self.is_unique
        
  # end
  
end