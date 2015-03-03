require 'rubygems'  # not necessary for Ruby 1.9
require 'minitest/autorun'
require_relative '../lib/parser'
require_relative '../lib/database'

class ParserTest < Minitest::Test

	@@connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 3\n"
	@@ip = '78.46.19.144'
	@@identd = '-'
	@@userid = '-'
	@@datetime = '[18/Jan/2015:06:27:04 +0100]'
	@@request = "GET /cuacfm-128k.mp3 HTTP/1.1"
	@@status = '200'
	@@bytes = '115396'
	@@referrer = '-'
	@@user_agent = "iTunes/9.1.1"
	@@seconds_connected = '3'

	# Inicializa el entorno
	def init_env
		Database.initialize_db
		Parser.initialize_parser
	end
	
	def teardown
    	Database.cleanConnectionCollection
  	end

	def createLogFile
		if (File.exist? "logTest")
			File.delete "logTest"
		end
		f = File.new("logTest", "w+")
		f.write(@@connection)
		f.close
	end

	def test_generateLogFile
		init_env
		createLogFile
		Parser.parse 'logTest'
		collection = Database.getConnectionCollection
		result = collection.find.to_a
		assert (result[0]["ip"] == @@ip) && (result[0]["identd"] == @@identd) && (result[0]["userid"] == @@userid) &&
				(result[0]["datetime"] == @@datetime) && (result[0]["request"] == @@request) && (result[0]["status"] == @@status) &&
				(result[0]["bytes"] == @@bytes) && (result[0]["referrer"] == @@referrer) &&
				(result[0]["user_agent"] == @@user_agent) && (result[0]["seconds_connected"] == @@seconds_connected)
	end

	#def test_expected_parser_not_initialized
	#	assert_raises(NoMethodError) {Parser.parse 'logTest'}
	#end

end