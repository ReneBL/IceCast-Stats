module ParserXML

	def self.initialize_xml
		config = YAML.load(ERB.new(File.read("#{Rails.root}/config/parser_xml_config.yml")).result)
		path = config['xml_path']
		f = File.open(path)
		@@doc = Nokogiri::XML(f)
		f.close
	end

	# Recibe un datetime y un source que servirá para obtener el día en el que buscar y el source por el que filtrar
	def self.get_programs datetime, source
		day = date_to_wday datetime
		program_list = []
		if ((contains_source? source) && (at_date_range? datetime))
			res = @@doc.xpath("//schedule//day[@weekday=\"#{day}\"]")
			res.children.select(&:element?).each { |node|
				program_list << {"start_time" => node.values[0], "end_time" => node.values[1], "program" => node.values[4]}
			}
		end
		program_list
	end

	def self.date_to_wday datetime
		days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
		# Tenemos que hacer to_time.to_date para tener en cuenta el offset de las zonas horarias
		day_int = datetime.to_time.to_date.cwday
		days[day_int-1]
	end

	def self.contains_source? source
		!@@doc.xpath("//sources/source[@name=\"#{source}\"]").empty?
	end

	def self.at_date_range? date
		from = DateTime.strptime(@@doc.xpath("//schedule/@valid_from").first.content, '%Y-%m-%d')
		to = DateTime.strptime(@@doc.xpath("//schedule/@valid_until").first.content, '%Y-%m-%d')
		((date.to_date >= from.to_date) && (date.to_date <= to.to_date))
	end
end