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
        Rails.logger.error "Parser couldn't find file: #{path}"
        raise ParserException, "File not found"
      end 
    rescue ApacheLogRegex::ParseError => e
      Rails.logger.error "Parser format exception #{e.message}"
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
      seconds = line["(%{ratio}n)"]
      unless(seconds.to_i < 5)
        request = line["%r"]
        source = ParserHelper.source_from_request request
        date = ParserHelper.string_to_datetime line["%t"]
        # Obtenemos los programas para esta fecha y source
        programs = ParserXML.get_programs date, source, seconds
        # Una vez los tenemos, los procesamos para saber qué programas ha escuchado el oyente en base a la fecha de fin de conexion
        # y los segundos que ha escuchado, lo que nos permitira extraer la hora de inicio
        listened = (programs.empty?) ? [] : (programs_listened programs, date, seconds)
        mongo_date = ParserHelper.date_to_mongodate date
        cnt, reg, ct, ct_code = Parser.get_geo_info line["%h"]
        connection = Connection.create!(ip: line["%h"], identd: line["%l"], userid: line["%u"], datetime: mongo_date, request: request,
          status: line["%>s"], bytes: line["%b"], referrer: line["%{Referer}i"], user_agent: line["%{User-agent}i"],
          seconds_connected: seconds, city: ct, region: reg, country: cnt, country_code: ct_code)
        connection.programs.create!(listened)
      end
    rescue Mongoid::Errors::Validations
      raise ParserException, "Datos inválidos: [line: #{line}]"
    rescue NoMethodError
      raise ParserException, "Linea nula: [#{line}]"
    rescue ArgumentError
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
  
  def Parser.get_geo_info ip
    geoinfo = Rails.cache.read ip
    unless (geoinfo != nil)
      solvedIp = Geocoder.search ip
      Rails.cache.write(ip, solvedIp, expires_in: 12.hours) if (!solvedIp.empty?)
    end
    if (geoinfo == nil || geoinfo.empty?)
      Rails.logger.warn "Problema en la resolución de localización para la ip ~> #{ip}"
      ["", "", "", ""]
    else
      data = geoinfo[0].data
      [data["country_name"], data["region_name"], data["city"], data["country_code"]]
    end
  end

  def Parser.programs_listened schedule, end_of_connection, seconds
  	result = []
    start_of_connection = (!ParserXML.at_date_range? (end_of_connection.to_time - seconds.to_i.seconds)) ? 
        (ParserXML.reset_start start_of_connection) : (end_of_connection.to_time - seconds.to_i.seconds)
    end_of_connection = (!ParserXML.at_date_range? end_of_connection) ? (ParserXML.reset_end end_of_connection) : 
        end_of_connection
    while (start_of_connection.to_time < end_of_connection.to_time) do
      unless (!ParserXML.at_date_range? start_of_connection)
        begin
          day_schedule = schedule.fetch(ParserHelper.date_to_wday start_of_connection)
          program = day_schedule.find { |program|
            end_day = ParserHelper.format_if_end_day program["end_time"]
            (program["start_time"] <= start_of_connection.to_time.strftime("%H:%M:%S")) and 
            (start_of_connection.to_time.strftime("%H:%M:%S") < end_day)
          }
          end_broadcast_time = ParserHelper.str_to_date_reference start_of_connection, program["end_time"]
          total = (end_broadcast_time - start_of_connection.to_time).abs.round
          seconds_listened = ((start_of_connection.to_time + total) > end_of_connection.to_time) ? 
            (end_of_connection.to_time - start_of_connection.to_time).abs.round : total
          result << (ParserHelper.create_program_element program["program"], seconds_listened)
          start_of_connection = start_of_connection.to_time + seconds_listened
        rescue KeyError => e
          Rails.logger.error "No se encuentra clave: #{e}"
        end
      end
    end
  	result
  end

end