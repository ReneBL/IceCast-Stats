require 'test_helper'
require "#{Rails.root}/lib/parser"
require "#{Rails.root}/lib/database"

class ParserTest < ActiveSupport::TestCase

  @@connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 3\n"
  @@connection2 = "208.94.246.226 - - [19/Jan/2015:16:03:31 +0100] \"GET /cuacfm.mp3 HTTP/1.0\" 200 68999 \"-\" \"Winamp 2.81\" 1\n"
  @@connection3 = "81.45.53.99 - - [19/Jan/2015:16:08:41 +0100] \"GET /cuacfm.mp3 HTTP/1.1\" 200 689633 \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.2.2; GT-S7580 Build/JDQ39)\" 79\n"
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
    for i in 0..(result.count - 1)
      valid = valid && (result[i]["ip"] == connections[i].ip) && (result[i]["identd"] == connections[i].identd) &&
      (result[i]["userid"] == connections[i].userid) && (result[i]["datetime"] == connections[i].datetime) &&
      (result[i]["request"] == connections[i].request) && (result[i]["status"] == connections[i].status) &&
      (result[i]["bytes"] == connections[i].bytes) && (result[i]["referrer"] == connections[i].referrer) &&
      (result[i]["user_agent"] == connections[i].user_agent) &&
      (result[i]["seconds_connected"] == connections[i].seconds_connected)
    end
    valid
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

  test "parse file with invalid format" do
    writeToFile @@bad_format_connection
    err = assert_raises(ParserException) {Parser.parse 'logTest'}
    assert_equal "Formato incorrecto", err.message
  end

  test "parse line with invalid datetime" do
    line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "18/Jajfg00", "%>s" => 200,
      "%b" => 100, "%r" => "GET /cuacfm-128k.mp3 HTTP/1.1", "%{Referer}i" => "-", "%{User-agent}i" => "", "(%{ratio}n)" => 1 }
    err = assert_raises(ParserException) {Parser.persist_line line}
    assert_equal "Formato de fecha incorrecto", err.message
  end

  test "parse line with invalid data" do
    line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "[18/Jan/2015:06:27:04 +0100]", "%>s" => 800,
      "%b" => -1, "%r" => "", "%{Referer}i" => "", "%{User-agent}i" => "", "(%{ratio}n)" => -1 }
    err = assert_raises(ParserException) {Parser.persist_line line}
    assert_equal "Datos inválidos", err.message
  end

  test "parse nil line" do
    err = assert_raises(ParserException) {Parser.persist_line nil}
    assert_equal "Linea nula", err.message
  end
  
  test "parse non existent file" do
    err = assert_raises(ParserException) {Parser.parse 'NonExistentFile'}
    assert_equal "File not found", err.message
  end
end