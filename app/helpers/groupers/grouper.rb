class Grouper

	def initialize qp, match_session
		@qp = qp
		@match = match_session
	end

	def project_part
	end

	def group_part
	end

  def self.match_part
    # El filtro match ya estará inicializado, bien a vacio o bien al filtro correspondiente si la request llega
    # con un source metido en la session
    @match["$match"].merge!({"datetime" => {"$gte" => @qp.start_date, "$lte" => @qp.end_date}})
    @match
  end

  def self.sort_part
    sort = {"$sort" => {"_id" => 1}}
    sort
  end

  def dynamic_parts
  	match = match_hours_part
  	unwind, group = distinct_visitors_count
  	[match, unwind, group]
  end

  def match_hours_part
  	if ((@qp.start_hour != nil) && (@qp.end_hour != nil))
      hour_start, minute_start, second_start = @qp.start_hour.split ":"
      hour_end, minute_end, second_end = @qp.end_hour.split ":"
      match = {"$match" => {"hour" => {"$gte" => hour_start, "$lte" => hour_end},
          "minute" => {"$gte" => minute_start, "$lte" => minute_end}, "second" => {"$gte" => second_start, "$lte" => second_end}}}
      match 
    else
      []
    end
  end

  def distinct_visitors_count        
    unwind = {"$unwind" => "$ips"}
    group = {"$group" => {"_id" => "$_id", "count" => {"$sum" => 1}}}
    [unwind, group]
  end
end