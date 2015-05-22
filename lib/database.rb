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