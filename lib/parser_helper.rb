module ParserHelper

	def self.string_to_datetime str
		time = str
    	date = DateTime.strptime(time, "[%d/%b/%Y:%H:%M:%S %z]")
    	date
  	end

  	def self.source_from_request request
    	# Una request siempre tendrá formato => (GET|POST|HEAD|PUT|DELETE) /path HTTP/(1.0|1.1)
    	# por lo tanto, partimos el string por espacios y nos quedamos con el segundo elemento, que es /path
    	# Luego, devolvemos la subcadena desde 1 hasta su propia longitud, lo que permite que nos saltemos el "/"
    	formatted = request.split(" ")[1]
    	(formatted == nil) ? "" : formatted[1..formatted.length]
  	end

  	def self.str_to_date_reference date_reference, str
  		# Tenemos que crear un Time con mktime puesto que strptime nos coge año, mes, y dia actual, y nosotros queremos comparar horas que
  		# se encuentren en un mismo dia en base a una data de referencia que se nos pasa como parámetro
  		time_temp = Time.strptime(str, "%H:%M:%S")
  		formatted_time = Time.mktime(date_reference.to_time.year, date_reference.to_time.month, 
  			date_reference.to_time.day, time_temp.hour, time_temp.min, time_temp.sec)
  		formatted_time
  	end

  	def self.create_program_element program, seconds
  		temp = {}
  		temp["name"] = program
  		temp["seconds_listened"] = seconds
  		temp
  	end

end