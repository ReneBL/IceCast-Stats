require 'rubygems'
require 'bson'
require 'moped'

module Database

	# Inicializa los parámetros de conexión a la BD
	def Database.initialize_db
		@db = Moped::Session.new([ "127.0.0.1:27017" ])
		@db.use :ice_cast_stats_test
	end

	# Devuelve la colección connCollection
	def Database.getConnectionCollection
    collection = @db["connCollection"]
    collection
	end
	
	def Database.cleanConnectionCollection
	  @db.drop
	end

end