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

    def self.date_to_wday datetime
    	days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    	# Tenemos que hacer to_time.to_date para tener en cuenta el offset de las zonas horarias
    	day_int = datetime.to_time.to_date.cwday
    	days[day_int-1]
  	end

  	def self.format_if_end_day hour
  		(hour == "00:00:00") ? "24:00:00" : hour
  	end

  	def self.date_to_mongodate datetime
  		DateTime.evolve(datetime)
  	end
end