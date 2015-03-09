require 'test_helper'
require "#{Rails.root}/lib/parser"
require "#{Rails.root}/lib/database"

class ParserTest < ActiveSupport::TestCase

  @@connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396 \"-\" \"iTunes/9.1.1\" 3\n"
  @@bad_format_connection = "78.46.19.144 - - [18/Jan/2015:06:27:04 +0100] \"GET /cuacfm-128k.mp3 HTTP/1.1\" 200 115396\n"
  
  # Inicializa el entorno
  def setup
    Database.initialize_db
    Parser.initialize_parser
    createLogFile
  end

  def teardown
    Database.cleanConnectionCollection
  end

  def createLogFile
    if (File.exist? "logTest")
      File.delete "logTest"
    end
    @f = File.new("logTest", "w+")
  end
  
  def writeToFile line
    @f.write(line)
    @f.close
  end

  test "parse file and retrieve data" do
    writeToFile @@connection
    Parser.parse 'logTest'
    collection = Database.getConnectionCollection
    connection = build(:connection_ok)
    result = collection.find.to_a
    assert (result[0]["ip"] == connection.ip) && (result[0]["identd"] == connection.identd) && 
           (result[0]["userid"] == connection.userid) && (result[0]["datetime"] == connection.datetime) && 
           (result[0]["request"] == connection.request) && (result[0]["status"] == connection.status) &&
           (result[0]["bytes"] == connection.bytes) && (result[0]["referrer"] == connection.referrer) &&
           (result[0]["user_agent"] == connection.user_agent) && (result[0]["seconds_connected"] == connection.seconds_connected)
  end
  
  test "parse file with invalid format" do
    writeToFile @@bad_format_connection
    err = assert_raises(ParserException) {Parser.parse 'logTest'}
    assert_equal "Formato incorrecto", err.message
  end

  test "parse line with invalid datetime" do
    line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "18/Jajfg00", "%>s" => 200,
      "%b" => 100, "%{Referer}i" => "-", "%{User-agent}i" => "", "(%{ratio}n)" => 1 }
    err = assert_raises(ParserException) {Parser.persist_line line}
    assert_equal "Formato de fecha incorrecto", err.message
  end
  
  test "parse line with invalid data" do
    line = {"%h" =>  "78.46.19.144", "%l" => "-" , "%u" => "-", "%t" => "[18/Jan/2015:06:27:04 +0100]", "%>s" => 800,
      "%b" => -1, "%{Referer}i" => "", "%{User-agent}i" => "", "(%{ratio}n)" => -1 }
    err = assert_raises(ParserException) {Parser.persist_line line}
    assert_equal "Datos inválidos", err.message
  end
  
  test "parse nil line" do
    err = assert_raises(ParserException) {Parser.persist_line nil}
    assert_equal "Linea nula", err.message
  end

end