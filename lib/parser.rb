require "#{Rails.root}/lib/exceptions/parserException"

module Parser

  def Parser.initialize_parser
    # Inicializa las variables necesarias para el parser. Dado que las constantes exponen el valor de estas
    # se utilizan variables de instancia para obtener ocultación y encapsulación de la información
    @config = YAML.load_file('config/parser_config.yml')
  end

  # Recorre las línes del fichero de log que se pasa como parámetro, por defecto el fichero de log del servidor
  def Parser.parse(path=@config['log_path'])
    begin
      format=@config['log_format']
      parser = ApacheLogRegex.new(format)
      File.foreach(path) do |line|
        result = parser.parse!(line)
        persist_line result
      end
    rescue ApacheLogRegex::ParseError => e
      Parser.write_log "Parser format exception #{e.message}"
      raise ParserException, "Formato incorrecto"
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
  def Parser.string_to_datetime str
    time = str
    date = DateTime.evolve(DateTime.strptime(time, "[%d/%b/%Y:%H:%M:%S %Z]"))
    date
  end
  
  def Parser.write_log message
    Rails.logger.warn message
  end
  
  def Parser.get_geo_info ip
    info = Geocoder.search ip
    [info[0].data["country_name"], info[0].data["region_name"], info[0].data["city"]]
  end
end