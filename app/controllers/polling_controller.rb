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
