=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

module ParserXML

	def self.initialize_xml
		initialize_parser
		path = @config['xml_schedule_path']
		f = File.open(path)
		@doc = Nokogiri::XML(f)
		f.close
	end

	def self.initialize_live_xml
		initialize_parser
		path_live = @config['xml_live_path']
		f = File.open(path_live)
		@doc_live = Nokogiri::XML(f) { |config| config.noblanks }
		f.close
	end

	# Recibe un datetime, un source y los segundos escuchados que servirán para obtener la programación del/los días
	# que ha escuchado el oyente
	def self.get_programs datetime, source, seconds
		program_list = {}
		unless (!contains_source? source)
			begin_listening = datetime.to_time - seconds.to_i
			days = []
			days << (ParserHelper.date_to_wday begin_listening) if (at_date_range? begin_listening)
			# Puede ser que haya estado conectado más de 1 día, por lo tanto, obtenemos la fecha inicio, su día
			# y vamos sumandole 1 hasta llegar al día de desconexión
			begin_listening = begin_listening.to_time.to_date + 1
			while (begin_listening.to_time.to_date <= datetime.to_time.to_date)
				# Si está fuera de horario de programación, no lo contamos
				days << (ParserHelper.date_to_wday begin_listening) if (at_date_range? begin_listening)
				begin_listening = begin_listening.to_time.to_date + 1
			end
			days.each { |day|
				program_list[day] = []
				res = @doc.xpath("//schedule//day[@weekday=\"#{day}\"]")
				res.children.select(&:element?).each { |node|
					program_list[day] << {"start_time" => node.values[0], "end_time" => node.values[1], "program" => node.values[4]}
				}
			}
		end
		program_list
	end

	def self.contains_source? source
		!@doc.xpath("//sources/source[@name=\"#{source}\"]").empty?
	end

	def self.at_date_range? date
		from = DateTime.strptime(@doc.xpath("//schedule/@valid_from").first.content, '%Y-%m-%d')
		to = DateTime.strptime(@doc.xpath("//schedule/@valid_until").first.content, '%Y-%m-%d')
		((date.to_time.to_date >= from.to_time.to_date) && (date.to_time.to_date <= to.to_time.to_date))
	end

	def self.reset_start datetime
		from = DateTime.strptime(@doc.xpath("//schedule/@valid_from").first.content, '%Y-%m-%d')
		datetime = from.to_time.to_date
		datetime
	end

	def self.reset_end datetime
		to = DateTime.strptime(@doc.xpath("//schedule/@valid_until").first.content, '%Y-%m-%d')
		datetime = to.to_time.to_date + 1
		datetime
	end

	def self.get_program_meta_info name
		meta_info = {}
		meta_info_xml = @doc_live.xpath("//showinfo[title/text()=\'#{name}\']")
		return meta_info if meta_info_xml.empty?
		meta_info["description"] = meta_info_xml.at("description").text
		meta_info["guid"] = meta_info_xml.at("guid").text
		meta_info["link"] = meta_info_xml.at("link").text
		meta_info
	end

	private

	def self.initialize_parser
		@config = YAML.load(ERB.new(File.read("#{Rails.root}/config/parser_xml_config.yml")).result)
	end
end
