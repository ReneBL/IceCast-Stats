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

require 'net/http'

class PollingController < ApplicationController

	def poll
		url = params[:route]
		uri = URI.parse(url)
		begin
			response_raw = Net::HTTP.get_response(uri)
			JsonSchemaValidator.valid? response_raw.body
			response = set_program_info!(JSON.parse(response_raw.body))
		rescue TypeError, SocketError
			response = {"error" => "La dirección no es válida o no pertenece a un servidor de streaming IceCast."}
		rescue JSON::Schema::ValueError, JSON::ParserError
			response = {"error" => "Datos incorrectos. Por favor, compruebe que la URL del servidor IceCast es correcta."}
		end
		render :json => response
	end

	private

	def set_program_info! response
		ParserXML.initialize_live_xml
		meta_inf = ParserXML.get_program_meta_info(response["icestats"]["source"][0]["yp_currently_playing"])
		response["description"] = (meta_inf["description"] ||= "")
		response["guid"] = (meta_inf["guid"] ||= "")
		response["link"] = (meta_inf["link"] ||= "")
		response
	end
end
