require 'parser'

class ConnectionsController < ApplicationController
  before_action :generate_query_params, only: [:connections_between_dates]
  
  def index
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
    project, group_by, error = DynamicQueryResolver.project_group_parts
    if error == nil
      # Al resolver le pasamos el match inicializado por el controller padre que puede contener el filtro,
      # si se da el caso, de los sources
      filters = []
      filters << (DynamicQueryResolver.match_part @match)
      if project != nil && group_by != nil
        # Le decimos al resolver que nos de el filtro por horas si existe, si no, devolvera [], lo cual para el 
        # pipeline no es relevante
        filters << project << DynamicQueryResolver.hours_filter << group_by
        #debugger
        if DynamicQueryResolver.is_unique
          unwind, group = DynamicQueryResolver.distinct_visitors_count
          filters << unwind << group
        end
        filters << DynamicQueryResolver.sort_part
        result = Connection.collection.aggregate(filters)
        render :json => result
      end
    else
      render :json => error.to_json
    end
  end
  
  private
  # Metodo que se llamara cada vez que se realice una peticion al controlador. Obtendrá los parámetros necesarios
  # para hacer la query y los encapsulará en un objeto QueryParams para inicializar el resolver
  def generate_query_params
    unique = unique_visitor_param
    start, finish_date = start_end_date_params
    start_hour, end_hour = start_end_hours
    qp = QueryParams.new(params[:group_by], unique, start, finish_date, start_hour, end_hour)
    DynamicQueryResolver.initialize qp
  end
  
  def start_end_hours
    st = params[:start_hour]
    fn = params[:end_hour]
    unless ((st == nil) && (fn == nil))  
      error_format = parse_date_time st, fn, "%H:%M:%S", "One hour is invalid. Correct format: HH:MM:SS"
      if (!error_format) 
        error_time = start_minor_end? st, fn, "Start time is lesser than end time"
        if (error_time)
          return
        end
      end
    end
    [st, fn]
  end

  def start_minor_end? start_hour, end_hour, msg
    hs, ms, ss = start_hour.split(":")
    he, me, se = end_hour.split(":")
    time_start = Time.new(1970, 1, 1, hs.to_i, ms.to_i, ss.to_i) 
    time_end = Time.new(1970, 1, 1, he.to_i, me.to_i, se.to_i)
    if (time_end < time_start)
      render :json => { "error" => msg }.to_json
      return true
    end
    return false
  end

  def start_end_date_params
    st_date = params[:start_date]
    end_date = params[:end_date]
    error = parse_date_time st_date, end_date, "%d/%m/%Y", "One date is invalid. Correct format: d/m/Y"  
    unless error
      formated_st, formated_end = ConnectionsHelper.begin_end_dates_to_mongo st_date, end_date
      return [formated_st, formated_end]
    end
    return
  end

  def parse_date_time st, fn, format, errormsg
    begin
      DateTime.strptime(st, format)
      DateTime.strptime(fn, format)
    rescue ArgumentError
      error = { "error" => errormsg }
      render :json => error.to_json
      return true
    end
    return false
  end
  
  def unique_visitor_param
    case params[:unique_visitors]
    when "true"
      unique = true
    when "false"
      unique = false
    end
    return unique
  end
  
end