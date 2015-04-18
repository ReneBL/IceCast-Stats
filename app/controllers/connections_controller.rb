require 'parser'

class ConnectionsController < ApplicationController
  before_action :start_end_date_params, :unique_visitor_param, only: [:connections_between_dates]
  
  def index
    # result = Connection.collection.aggregate(
        # {
          # "$project" => {'year' => {"$year" => "$datetime"}}
        # }, 
        # {
          # "$group" => {'_id' => {'year' => "$year"}, 'count' => {"$sum" => 1}}
        # }
    # )
    # respond_to do |format|
      # format.html
      # format.json {render :json => result}
    # end
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
    start, finish_date = ConnectionsHelper.begin_end_dates_to_mongo @st_date, @end_date
    project, group_by, error = DynamicQueryResolver.project_group_parts params[:group_by], @unique
    if error == nil
      match_filter = {"$match" => {"datetime" => {"$gte" => start, "$lte" => finish_date}}}
      sort = {"$sort" => {"_id" => 1}}
      if project != nil && group_by != nil
        if @unique
          unwind, group = DynamicQueryResolver.distinct_visitors_count
          result = Connection.collection.aggregate(match_filter, project, group_by, unwind, group, sort)
        else
          result = Connection.collection.aggregate(match_filter, project, group_by, sort)
        end
        render :json => result
      end
    else
      render :json => error.to_json
    end
  end
  
  private
  
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
  
  def unique_visitor_param
    case params[:unique_visitors]
    when "true"
      @unique = true
    when "false"
      @unique = false
    end
  end
  
end