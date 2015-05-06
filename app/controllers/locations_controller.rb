class LocationsController < StatsController

	def countries_time
		filters = []
		# Siempre llevará como primer stage el match de las fechas, por lo tanto, lo añadimos
    filters << (DynamicQueryResolver.match_part @match)
    # Inicializamos project y group
    project = {"$project" => {"country" => 1, "seconds_connected" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    # Añadimos la proyección de los segundos totales de la fecha por conexion
    DynamicQueryResolver.project_totalSeconds_decorator project 
    # Si estamos consultando el tiempo total de escucha, no podemos hacer una distinción de IP's únicas por que queremos
    # obtener el tiempo total 
    DynamicQueryResolver.count_seconds_group_by_part_decorator group_by
    # Añadimos las stages a filters
    filters << project << DynamicQueryResolver.hours_filter << group_by
    # Añadimos la stage de ordenación
    filters << DynamicQueryResolver.sort_part
    #debugger
    result = Connection.collection.aggregate(filters)
    render :json => result
	end

	def countries
		filters = []
		# Siempre llevará como primer stage el match de las fechas, por lo tanto, lo añadimos
    filters << (DynamicQueryResolver.match_part @match)
    # Inicializamos project y group
    project = {"$project" => {"country" => 1}}
    group_by = {"$group" => {"_id" => {"country" => "$country"}}}
    # Añadimos la proyección de los segundos totales por conexion
    DynamicQueryResolver.project_totalSeconds_decorator project 
    # Comprobamos si la query es por visitantes unicos
    if DynamicQueryResolver.is_unique
      # Si es así, decoramos project y group by para que agrupe por IP's y haga count gracias a unwind y un segundo group
      DynamicQueryResolver.project_ip_decorator project
      DynamicQueryResolver.group_by_distinct_visitors_decorator group_by
      unwind, group = DynamicQueryResolver.distinct_visitors_count
    else
    	# Si no, solo tenemos que preocuparnos de que se haga + 1 por cada documento que haga match con la query.
    	# Con este controlador, lo setearemos a mano con el decorador, porque esta query no tiene ningún cálculo especial
    	# en el group by como ranges o connections between dates
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

	private

	def common_process_countries filters, project, group_by
		
	end

end