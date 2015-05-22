require 'json'
require 'net/http'
require "#{Rails.root}/app/helpers/json_schema_validator"
require "#{Rails.root}/lib/parser_helper"

module ParserRT

	def self.initialize_parser
		@config = YAML.load_file('config/parser_rt_config.yml')
	end

	def self.automatic_start
		ParserRT.initialize_parser
		ParserRT.parse
	end

	def self.parse
		uri = URI.parse(@config['server_url'])
		begin
			response_raw = Net::HTTP.get_response(uri)
			JsonSchemaValidator.valid? response_raw.body
			resp_hash = JSON.parse(response_raw.body)
			date = ParserHelper.date_to_mongodate DateTime.now
			listeners = count_listeners resp_hash["icestats"]["source"]
			ConnectionRealTime.create!(datetime: date, listeners: listeners)
		rescue Mongoid::Errors::Validations => e
			Rails.logger.error "Mongoid Validation error: #{e.document}"
		rescue TypeError, SocketError
			Rails.logger.error "ParserRT ~> TypeError | SocketError : La dirección no es válida o no pertenece a 
				un servidor de streaming IceCast."
		rescue JSON::Schema::ValueError, JSON::ParserError
			Rails.logger.error "ParserRT ~> JSON Error : Datos incorrectos. Por favor, compruebe que la URL del 
				servidor IceCast es correcta."
		end
	end

	private

	def self.count_listeners sources
		listeners = 0
		sources.each {|source| 
			listeners += source["listeners"]
		}
		listeners
	end

end