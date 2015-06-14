require 'test_helper'
require "#{Rails.root}/lib/parser"
require "#{Rails.root}/lib/database"

class ParserTest < ActiveSupport::TestCase

	@@connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 5\n"
	@@connection2 = "208.94.246.226 - - [19/Jan/2015:16:03:31 +0100] \"GET /cuacfm.mp3 HTTP/1.0\" 200 68999 \"-\" \"Winamp 2.81\" 9\n"
	@@connection3 = "81.45.53.99 - - [19/Jan/2015:16:08:41 +0100] \"GET /cuacfm.mp3 HTTP/1.1\" 200 689633 \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.2.2; GT-S7580 Build/JDQ39)\" 79\n"
	@@connection_minor_than_5_seconds = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 3\n"

	@@connection_out_of_schedule = "78.46.19.144 - - [31/Mar/2015:08:10:00 UTC] \"GET /cuacfm.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 2400\n"
	@@monday_listening_FolkInTrio_ElRinconcito = "78.46.19.144 - - [05/Apr/2015:23:10:00 UTC] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 3600\n"
	@@not_scheduled_source = "78.46.19.144 - - [20/Apr/2015:23:10:00 UTC] \"GET /filispin.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 600\n"
	@@tuesday_listening_Spoiler = "78.46.19.144 - - [21/Apr/2015:20:40:00 UTC] \"GET /cuacfm.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 2400\n"
	@@friday_listening_Informativos_Radiocassette_Sin_Etiq = "78.46.19.144 - - [15/May/2015:07:40:00 UTC] \"GET /cuacfm.aac HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 9000\n"
	@@listening_before = "78.46.19.144 - - [31/Mar/2015:23:10:00 UTC] \"GET /cuacfm.mp3 HTTP/1.1\" 200 11111 \"-\" \"iTunes/9.1.1\" 5400\n"
	@@listening_after = "78.46.19.144 - - [01/Jun/2015:22:05:00 UTC] \"GET /cuacfm.mp3 HTTP/1.1\" 200 1000 \"-\" \"iTunes/9.1.1\" 4200\n"

	@@bad_format_connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396\n"
	# Inicializa el entorno
	def setup
		Database.initialize_db
		Parser.initialize_parser
		createLogFile
	end

	def teardown
		Database.cleanConnectionCollection
		config = YAML.load_file('config/parser_config.yml')
		config['seek_pos'] = 0
		config['last_line'] = ""
		File.open('config/parser_config.yml', 'w+') {|f| f.write config.to_yaml }
		File.delete 'logTest'
		unless !File.exists? 'logTest2'
			File.delete 'logTest2'
		end
	end

	def createLogFile
		if (File.exist? "logTest")
			File.delete "logTest"
		end
		@f = File.new("logTest", "w+")
	end

	def writeToFile *lines
		lines.each do |line|
			@f.write line
			@f.flush
		end
	end

	def comparator result, connections
		valid = true
		valid_progs = true
		for i in 0..(result.count - 1)
			valid = valid && (result[i]["ip"] == connections[i].ip) && (result[i]["identd"] == connections[i].identd) &&
			(result[i]["userid"] == connections[i].userid) && (result[i]["datetime"] == connections[i].datetime) &&
			(result[i]["request"] == connections[i].request) && (result[i]["status"] == connections[i].status) &&
			(result[i]["bytes"] == connections[i].bytes) && (result[i]["referrer"] == connections[i].referrer) &&
			(result[i]["user_agent"] == connections[i].user_agent)  && (result[i]["seconds_connected"] == connections[i].seconds_connected)
			prog = result[i]["programs"] ||= []
			if prog.empty?
				valid = valid && (prog == connections[i].programs)
			else
				if (!connections[i].programs.empty? && (prog.count == connections[i].programs.size))
					for j in 0..(prog.count - 1)
						valid_progs = valid_progs && (prog[j]["name"] == connections[i].programs[j].name) &&
													(prog[j]["seconds_listened"] == connections[i].programs[j].seconds_listened)
					end
				else
					valid_progs = false
				end
			end
		end
		valid && valid_progs
	end

	test "parse file and retrieve data" do
		writeToFile @@connection, @@connection2, @@connection3
		Parser.parse 'logTest'
		collection = Database.getConnectionCollection
		connection = build(:connection_ok)
		connection2 = build(:connection2)
		connection3 = build(:connection3)
		connections = [connection, connection2, connection3]
		result = collection.find.to_a
		assert_equal result.count, 3
		assert comparator result, connections
	end

	test "parse log file multiple time" do
		writeToFile @@connection, @@connection2
		Parser.parse 'logTest'
		collection = Database.getConnectionCollection

		connection = build(:connection_ok)
		connection2 = build(:connection2)
		connections = [connection, connection2]

		result = collection.find.to_a
		assert_equal result.count, 2
		assert comparator result, connections

		writeToFile @@connection3
		Parser.parse 'logTest'
		connection3 = build(:connection3)
		connections.push(connection3)
		result = collection.find.to_a
		assert_equal result.count, 3
		assert comparator result, connections

		writeToFile @@connection
		Parser.parse 'logTest'
		connection4 = build(:connection_ok)
		connections.push(connection4)
		result = collection.find.to_a
		assert_equal result.count, 4
		assert comparator result, connections
	end

	test "simulate log file rotation" do
		writeToFile @@connection
		Parser.parse 'logTest'
		connections = [build(:connection_ok)]
		# Recupero de BD
		collection = Database.getConnectionCollection
		result = collection.find.to_a
		# Comparo resultado de BD con linea procesada
		assert_equal result.count, 1
		assert comparator result, connections
		# Renombro logTest
		File.rename("logTest", "logTest2")
		createLogFile
		# Escribo connection1 y connection2
		writeToFile @@connection2
		writeToFile @@connection3
		connections.push build(:connection2)
		connections.push build(:connection3)
		# Levanto el parser
		Parser.parse 'logTest'
		# Recupero de BD
		result2 = collection.find.to_a
		# Comparo resultado de BD con las lineas totales procesadas
		assert_equal result2.count, 3
		assert comparator result2, connections
	end

	test "parse 4 connections, one with seconds < 5" do
		writeToFile @@connection, @@connection2, @@connection3, @@connection_minor_than_5_seconds
		Parser.parse 'logTest'
		connections = [build(:connection_ok), build(:connection2), build(:connection3)]
		collection = Database.getConnectionCollection
		result = collection.find.to_a
		assert_equal result.count, 3
		assert comparator result, connections
	end

	test "parse programs info" do
		writeToFile @@connection_out_of_schedule, @@monday_listening_FolkInTrio_ElRinconcito, @@not_scheduled_source,
			@@tuesday_listening_Spoiler, @@friday_listening_Informativos_Radiocassette_Sin_Etiq, @@listening_before,
			@@listening_after
		Parser.parse 'logTest'
		connections = [build(:connection_out_of_schedule), build(:monday_listening_FolkInTrio_ElRinconcito),
			build(:not_scheduled_source), build(:tuesday_listening_Spoiler),
			build(:friday_listening_Informativos_Radiocassette_Sin_Etiq), build(:listening_from_before_schedule),
			build(:listening_until_after)
		]
		collection = Database.getConnectionCollection
		result = collection.find.to_a
		assert_equal result.count, 7
		assert comparator result, connections
	end

	test "parse file with invalid format" do
		writeToFile @@bad_format_connection
		err = assert_raises(ParserException) {Parser.parse 'logTest'}
		assert_equal "Formato incorrecto", err.message
	end

	test "parse line with invalid datetime" do
		line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "18/Jajfg00", "%>s" => 200,
			"%b" => 100, "%r" => "GET /cuacfm-128k.mp3 HTTP/1.1", "%{Referer}i" => "-", "%{User-agent}i" => "", "(%{ratio}n)" => 10 }
		err = assert_raises(ParserException) {Parser.persist_line line}
		assert_equal "Formato de fecha incorrecto", err.message
	end

	test "parse line with invalid data" do
		line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "[18/Jan/2015:06:27:04 +0100]", "%>s" => 800,
			"%b" => -1, "%r" => "", "%{Referer}i" => "", "%{User-agent}i" => "", "(%{ratio}n)" => 100 }
		err = assert_raises(ParserException) {Parser.persist_line line}
		assert_equal "Datos inválidos: [line: {\"%h\"=>\"78.46.19.144\", \"%l\"=>\"-\", \"%u\"=>\"-\", \"%t\"=>\"[18/Jan/2015:06:27:04 +0100]\", \"%>s\"=>800, \"%b\"=>-1, \"%r\"=>\"\", \"%{Referer}i\"=>\"\", \"%{User-agent}i\"=>\"\", \"(%{ratio}n)\"=>100}]", err.message
	end

	test "parse nil line" do
		err = assert_raises(ParserException) {Parser.persist_line nil}
		assert_equal "Linea nula: []", err.message
	end

	test "parse non existent file" do
		err = assert_raises(ParserException) {Parser.parse 'NonExistentFile'}
		assert_equal "File not found", err.message
	end

	test "obtain programs meta info" do
		ParserXML.initialize_live_xml
		result = ParserXML.get_program_meta_info "Fantasma accidental"
		assert_not_nil result
		assert_equal result["description"], "Un programa sobre a música alternativa galega e as súas conexións, nunha viaxe de ida e volta no tempo e no espazo."
		assert_equal result["guid"], "Musical"
		assert_equal result["link"], "http://programacion.cuacfm.org/android/img/fantasma.png"
	end

	test "obtain non existing program meta info" do
		ParserXML.initialize_live_xml
		result = ParserXML.get_program_meta_info ""
		assert true, result.empty?
		result = ParserXML.get_program_meta_info "Fake Program"
		assert true, result.empty?
		result = ParserXML.get_program_meta_info 0
		assert true, result.empty?
		result = ParserXML.get_program_meta_info nil
		assert true, result.empty?
	end
end
