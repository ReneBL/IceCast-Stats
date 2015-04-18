module DynamicQueryResolver
  
  def self.project_group_parts group_by, unique
    error = nil
    case group_by
    when "year"   
      if unique
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "datetime" => 1, "ip" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year"}, "ips" => {"$addToSet" => "$ip"}}}
      else
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "datetime" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year"}, "count" => {"$sum" => 1}}}
      end
    when "month"
      if unique
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1, "ip" => 1}}
        group = {"$group" => { "_id" => {"year" => "$year", "month" => "$month"}, "ips" => {"$addToSet" => "$ip"}}}
      else
        project = {"$project" => {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1}}
        group = {"$group" => {"_id" => {"year" => "$year", "month" => "$month"}, "count" => {"$sum" => 1}}}
      end
    when "day"
      if unique
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
    [project, group, error]
  end
  
  def self.distinct_visitors_count        
    unwind = {"$unwind" => "$ips"}
    group = {"$group" => {"_id" => "$_id", "count" => {"$sum" => 1}}}
    [unwind, group]
  end
  
end