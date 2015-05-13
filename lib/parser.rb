require "#{Rails.root}/lib/exceptions/parserException"
require "#{Rails.root}/lib/parser_xml"
require "#{Rails.root}/lib/parser_helper"

module Parser

  def Parser.initialize_parser
    # Inicializa las variables necesarias para el parser. Dado que las constantes exponen el valor de estas
    # se utilizan variables de instancia para obtener ocultación y encapsulación de la información
    @config = YAML.load_file('config/parser_config.yml')
    ParserXML.initialize_xml
  end

  def Parser.parse_without_path
    Parser.initialize_parser
    Parser.parse @config['log_path']
  end

  # Recorre las línes del fichero de log que se pasa como parámetro, por defecto el fichero de log del servidor
  # Además, obtiene el offset del fichero de configuración para obviar las líneas que ya han sido parseadas
  # Por último actualiza dicho fichero de configuración guardando el offset donde se ha quedado 
  def Parser.parse(path)
    begin
      # Pasamos a string para evitar que nos manden nil o cualquier otro tipo de dato
      if File.exists? path.to_s
        parser = ApacheLogRegex.new(@config['log_format'])
        f = File.open(path, 'r+')
        #f.seek(@config['seek_pos'], :SET)
        #line = f.gets
        line = get_first_line_to_read f
        unless line == nil
          while (true) do
            begin
              result = parser.parse!(line)
              persist_line result
              line = f.readline
            rescue EOFError
              break
            end
          end
        end
      else
        Parser.write_log "Parser couldn't find file: #{path}"
        raise ParserException, "File not found"
      end 
    rescue ApacheLogRegex::ParseError => e
      Parser.write_log "Parser format exception #{e.message}"
      raise ParserException, "Formato incorrecto"
    ensure
      unless f == nil
        @config['seek_pos'] = f.tell
        @config['last_line'] = line ||= ""
        File.open('config/parser_config.yml', 'w+') {|f| f.write @config.to_yaml }
      end
    end 
  end

  # Persiste una línea del fichero de log en la base de datos
  def Parser.persist_line(line)
    begin
    	# debugger
      seconds = line["(%{ratio}n)"]
      unless(seconds.to_i < 5)
        request = line["%r"]
        source = ParserHelper.source_from_request request
        date = ParserHelper.string_to_datetime line["%t"]
        # Obtenemos los programas para esta fecha y source
        #debugger
        programs = ParserXML.get_programs date, source
        # Una vez los tenemos, los procesamos para saber qué programas ha escuchado el oyente en base a la fecha de fin de conexion
        # y los segundos que ha escuchado, lo que nos permitira extraer la hora de inicio
        listened = (programs.empty?) ? [] : (programs_listened programs, date, seconds)
        mongo_date = DateTime.evolve(date)
        cnt, reg, ct = Parser.get_geo_info line["%h"]
        connection = Connection.create!(ip: line["%h"], identd: line["%l"], userid: line["%u"], datetime: mongo_date, request: request,
          status: line["%>s"], bytes: line["%b"], referrer: line["%{Referer}i"], user_agent: line["%{User-agent}i"],
          seconds_connected: seconds, city: ct, region: reg, country: cnt)
        connection.programs.create!(listened)
      end
    rescue Mongoid::Errors::Validations => e
       Parser.write_log "Invalid data parsing line #{e.message}"
       raise ParserException, "Datos inválidos"
    rescue NoMethodError => e
      Parser.write_log "Nil line #{e.message}"
      raise ParserException, "Linea nula"
    rescue ArgumentError => e
      Parser.write_log "Exception parsing date #{e.message}"
      raise ParserException, "Formato de fecha incorrecto"
    end
  end
  
  private
  # Obtenemos la primera línea a leer del fichero, comprobando si ha rotado o no desde la última vez
  def Parser.get_first_line_to_read file
    # Leemos parámetros de configuración: Offset y la última linea procesada
    offset = @config['seek_pos']
    last_line_read = @config['last_line']
    # Avanzamos hasta la posición anterior a la última linea procesada y obtenemos la linea. Para obtener la posición a
    # buscar, tenemos que comprobar el tamaño de la ultima linea leida, si es 0, no pasa nada, pero en caso contrario, es necesario
    # tener en cuenta el \n que se produce al leer la linea, y por eso se le suma 1 al bytesize
    seek_position = last_line_read.bytesize == 0 ? (offset - last_line_read.bytesize) : (offset - (last_line_read.bytesize + 1)) 
    file.seek(seek_position, :SET)
    last_line_file = file.gets
    # Si la línea que acabamos de leer es la misma que la última procesada, el log no ha rotado, por lo tanto,
    # avanzamos hasta el offset. En caso contrario, el log ha rotado, por lo que rebobinamos al inicio del fichero
    # Como antes ha leido la linea con el \n, usamos chomp para eliminarselo
    (last_line_read.eql? last_line_file.chomp) ? file.seek(offset, :SET) : file.seek(File::SEEK_SET, :SET)
    # Hacemos gets y no readline para evitar catch de la excepcion y devolver nil. 
    # Si es el final del fichero, devolvemos nil directamente
    line = file.gets
    line
  end
  
  def Parser.write_log message
    Rails.logger.warn message
  end
  
  def Parser.get_geo_info ip
    info = Rails.cache.fetch ip do
      solvedIp = Geocoder.search ip
      solvedIp
    end
    [info[0].data["country_name"], info[0].data["region_name"], info[0].data["city"]]
  end

  def Parser.programs_listened programs, end_of_connection, seconds
  	result = []
  	#debugger
  	start_of_connection = end_of_connection.to_time - seconds.to_i.seconds
  	# CASO BASE: Buscamos si existe algun programa que cubra toda la conexion
  	program = programs.find { |program|
  		#debugger
  		(program["start_time"] <= start_of_connection.to_time.strftime("%H:%M:%S")) and 
  		(start_of_connection.to_time.strftime("%H:%M:%S") <= program["end_time"]) and
  		(program["end_time"] >= end_of_connection.to_time.strftime("%H:%M:%S")) and 
  		(end_of_connection.to_time.strftime("%H:%M:%S") >= program["start_time"])
  	}
  	if (program != nil)
  		# Si entramos aqui, lo hemos encontrado de primeras, lo insertamos en el resultado
  		result << (ParserHelper.create_program_element program["program"], seconds.to_i)
  	else
  		# Si no, quiere decir que el oyente ha escuchado mas de un programa, por lo tanto comenzamos a procesar
  		# a partir del indice del array que contenga la información correspondiente a cuando el oyente comenzó a escuchar
  		#debugger
  		start_index = programs.find_index { |program| 
  			(program["start_time"] <= start_of_connection.to_time.strftime("%H:%M:%S")) and
  			(program["end_time"] >= start_of_connection.to_time.strftime("%H:%M:%S"))
  		}
  		# Antes de comenzar con el procesado, tenemos que añadir al resultado el programa que estaba sonando cuando se conecto
  		# más los segundos, que será la resta de la hora de finalización del programa menos la hora de inicio de la conexión
  		# IMPORTANTE => todas las restas deben hacerse con valor absoluto (.abs), ya que si queremos restar 00:00:00 - 23:50:01, por ejemplo, daría
  		# un numero negativo
  		program = programs.at(start_index)["program"]
  		end_broadcast_time = ParserHelper.str_to_date_reference start_of_connection, programs.at(start_index)["end_time"]
  		result << (ParserHelper.create_program_element program, (end_broadcast_time - start_of_connection.to_time).abs.round)
  		#Comienza el procesado desde posicion actual has el tamaño del array
  		(start_index + 1).upto(programs.size) { |i|
  			program_i_program = programs.at(i)["program"]
  			program_i_start_time = ParserHelper.str_to_date_reference end_of_connection, programs.at(i)["start_time"]
  			program_i_end_time = ParserHelper.str_to_date_reference end_of_connection, programs.at(i)["end_time"]
  			if (end_of_connection.to_time <= program_i_end_time)
  				# Si la hora de fin de conexión es menor que la de fin de programa, hemos terminado el procesado, salimos del bucle
  				#debugger
  				result << (ParserHelper.create_program_element program_i_program, (end_of_connection.to_time - program_i_start_time).abs.round)
  				break
  			else
  				# Si no, añadimos los datos al result y seguimos
  				result << (ParserHelper.create_program_element program_i_program, (program_i_end_time - program_i_start_time).abs.round)
  			end
  		}
  	end
  	result
  end

end