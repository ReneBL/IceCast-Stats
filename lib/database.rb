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

module Database

	# Inicializa los parámetros de conexión a la BD
	def Database.initialize_db
		@db = Moped::Session.new([ "127.0.0.1:27017" ])
		@db.use :ice_cast_stats_test
	end

	# Devuelve la colección connections
	def Database.getConnectionCollection
    @db["connections"]
	end

	def Database.getRealTimeCollection
		@db["connection_real_times"]
	end
	
	def Database.cleanConnectionCollection
	  @db.drop
	end

end