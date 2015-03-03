require 'apachelogregex'
require 'yaml'
require_relative 'database'

module Parser

  def Parser.initialize_parser
    # Inicializa las variables necesarias para el parser. Dado que las constantes exponen el valor de estas
    # se utilizan variables de instancia para obtener ocultación y encapsulación de la información
    @config = YAML.load_file('config/parser_config.yml')
    Database.initialize_db
    @collection = Database.getConnectionCollection
  end

  # Recorre las línes del fichero de log que se pasa como parámetro, por defecto el fichero de log del servidor
  def Parser.parse(path=@config['log_path'])
    format=@config['log_format']
    parser = ApacheLogRegex.new(format)
    File.foreach(path) do |line|
      result = parser.parse(line)
      persist_line result
    end
  end

  # Persiste una línea del fichero de log en la base de datos
  def Parser.persist_line(line)
    if line != nil
      line.replace({"ip" => line["%h"], "identd" => line["%l"], "userid" => line["%u"], "datetime" => line["%t"], "request" => line["%r"],
        "status" => line["%>s"], "bytes" => line["%b"], "referrer" => line["%{Referer}i"], "user_agent" => line["%{User-agent}i"],
        "seconds_connected" => line["(%{ratio}n)"]})
      @collection.insert(line)
    end
  end

end