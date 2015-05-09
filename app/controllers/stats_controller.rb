class StatsController < ApplicationController
  before_action :generate_query_params, only: [:connections_between_dates, :ranges, :countries,
    :countries_time, :total_seconds, :avg_seconds]

  # Esta "controlador" servirá como filtro de entrada a las peticiones destinadas a cualquiera de los controladores 
  # que hereden de éste

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
    #debugger
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
    else
      unique = false
    end
    return unique
  end
end