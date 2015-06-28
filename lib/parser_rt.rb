# encoding: UTF-8

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