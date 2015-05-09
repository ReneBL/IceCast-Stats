require "#{Rails.root}/lib/exceptions/parserException"

module Parser

  def Parser.initialize_parser
    # Inicializa las variables necesarias para el parser. Dado que las constantes exponen el valor de estas
    # se utilizan variables de instancia para obtener ocultación y encapsulación de la información
    @config = YAML.load_file('config/parser_config.yml')
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
      date = Parser.string_to_datetime line["%t"]
      cnt, reg, ct = Parser.get_geo_info line["%h"]
      Connection.create!(ip: line["%h"], identd: line["%l"], userid: line["%u"], datetime: date, request: line["%r"],
        status: line["%>s"], bytes: line["%b"], referrer: line["%{Referer}i"], user_agent: line["%{User-agent}i"],
        seconds_connected: line["(%{ratio}n)"], city: ct, region: reg, country: cnt)
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

  def Parser.string_to_datetime str
    time = str
    date = DateTime.evolve(DateTime.strptime(time, "[%d/%b/%Y:%H:%M:%S %Z]"))
    date
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
end