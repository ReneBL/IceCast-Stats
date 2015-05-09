require 'parser'

class ConnectionsController < StatsController
  
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

  def total_seconds
    filters = []
    filters << (DynamicQueryResolver.match_part @match)
    project = {"$project" => {"seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => "total"}}
    DynamicQueryResolver.project_totalSeconds_decorator project 
    DynamicQueryResolver.count_seconds_group_by_part_decorator group_by
    # Añadimos las stages a filters
    filters << project << DynamicQueryResolver.hours_filter << group_by
    # Añadimos la stage de ordenación
    filters << DynamicQueryResolver.sort_part
    result = Connection.collection.aggregate(filters)
    render :json => result
  end
  
  def ranges
    # Obtenemos los parametros min y max
    min, max, error = ranges_params
    # Si ha habido un error, salimos de la ejecución del método
    return if (error != nil)
    # Creamos el array de filtros
    filters = []
    # Siempre llevará como primer stage el match de las fechas, por lo tanto, lo añadimos
    filters << (DynamicQueryResolver.match_part @match)
    # Inicializamos project y group
    project = {"$project" => {"seconds_connected" => 1}}
    group_by = {"$group" => {}}
    # Añadimos la proyección de los segundos totales por conexion y el group by de los rangos, respectivamente
    DynamicQueryResolver.project_totalSeconds_decorator project 
    RangesHelper.ranges_resolver min, max, group_by
    # Comprobamos si la query es por visitantes unicos
    if DynamicQueryResolver.is_unique
      # Si es así, decoramos project y group by para que agrupe por IP's y haga count gracias a unwind y un segundo group
      DynamicQueryResolver.project_ip_decorator project
      DynamicQueryResolver.group_by_distinct_visitors_decorator group_by
      unwind, group = DynamicQueryResolver.distinct_visitors_count
      DynamicQueryResolver.count_group_by_part_decorator group
    else 
      DynamicQueryResolver.count_group_by_part_decorator group_by
    end
    # Añadimos las stages a filters
    filters << project << DynamicQueryResolver.hours_filter << group_by
    if ((unwind != nil) && (group != nil))
      filters << unwind << group
    end
    # Añadimos la stage de ordenación
    filters << DynamicQueryResolver.sort_part
    #debugger
    result = Connection.collection.aggregate(filters)
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
          DynamicQueryResolver.count_group_by_part_decorator group
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