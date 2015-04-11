require 'parser'

class ConnectionsController < ApplicationController
  before_action :start_end_date_params, :unique_visitor_param, only: [:connections_between_dates]
  
  def index
    result = Connection.collection.aggregate(
        {
          "$project" => {'year' => {"$year" => "$datetime"}}
        }, 
        {
          "$group" => {'_id' => {'year' => "$year"}, 'count' => {"$sum" => 1}}
        }
    )
    respond_to do |format|
      format.html
      format.json {render :json => result}
    end
  end
  
  def months
    year = params[:year].to_i
    result = Connection.collection.aggregate(
      {
        "$project" => {'month' => {'$month' => '$datetime'},'year' => {'$year' => '$datetime'}}
      },
      {
        '$match' => {'year' => year}
      },
      {
        "$group" => {'_id' => {'month' => '$month'},'count' => {'$sum' => 1}}
      },
      {
        "$sort" => {'_id' => 1}
      }
    )   
    render :json => result
  end
  
  def years
    result = Connection.collection.aggregate(
      {
        "$project" => {
          'year' => {"$year" => "$datetime"}
        }
      }, 
      {
        "$group" => { 
          '_id' => {'year' => "$year"}
         }
      }, 
      {
        "$sort" => {
          '_id' => -1
        }
      })
      render :json => result
  end
  
  def ranges
    result = Connection.collection.aggregate(
      { 
        "$project" => {"_id" => 0, "range" => {"$concat"=> 
          [
           {"$cond" => [{ "$lte" => ["$seconds_connected", 20] }, "range 0-20", ""]}, 
           {"$cond" => [{ "$and" => [{"$gt" => ["$seconds_connected", 20]},{"$lte" => ["$seconds_connected", 60]}]}, "range 20-60", ""]}, 
           {"$cond" => [{"$gt" => ["$seconds_connected", 60]}, "range > 60", "" ]}
          ]
        }
      }},
      { "$group" => { "_id" => "$range", "count" => { "$sum" => 1 }}},
      { "$sort" => { "_id" => 1 }}
    )
    render :json => result
  end
  
  def connections_between_dates
    start, finish_date = strings_to_datetime @st_date, @end_date
    project, group_by = dynamic_parts params[:group_by], @unique
    match_filter = {"$match" => {"datetime" => {"$gte" => start, "$lte" => finish_date}}}
    sort = {"$sort" => {"_id" => 1}}
    if project != nil && group_by != nil
      if @unique
        unwind, group = distinct_visitors_count
        result = Connection.collection.aggregate(match_filter, project, group_by, unwind, group, sort)
      else
        result = Connection.collection.aggregate(match_filter, project, group_by, sort)
      end
      render :json => result
    end
  end
  
  private
  
  def strings_to_datetime start, finish
    start += ":00:00:00"
    finish += ":23:59:59"
    dateStart = DateTime.evolve(DateTime.strptime(start, "%d/%m/%Y:%H:%M:%S"))
    dateFinish = DateTime.evolve(DateTime.strptime(finish, "%d/%m/%Y:%H:%M:%S"))
    [dateStart, dateFinish]
  end
  
  def start_end_date_params
    @st_date = params[:start_date]
    @end_date = params[:end_date]
    begin
      DateTime.strptime(@st_date, "%d/%m/%Y")
      DateTime.strptime(@end_date, "%d/%m/%Y")
    rescue ArgumentError
      error = { "error" => "One date is invalid. Correct format: d/m/Y"}
      render :json => error.to_json
    end
  end
  
  def dynamic_parts group_by, unique
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
      render :json => error.to_json
      return
    end
    [project, group]
  end
  
  def distinct_visitors_count        
    unwind = {"$unwind" => "$ips"}
    group = {"$group" => {"_id" => "$_id", "count" => {"$sum" => 1}}}
    [unwind, group]
  end
  
  def unique_visitor_param
    case params[:unique]
    when "true"
      @unique = true
    when "false"
      @unique = false
    end
  end
  
end