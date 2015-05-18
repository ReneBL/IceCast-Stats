require 'net/http'

class PollingController < ApplicationController

	def poll
		url = params[:route]
		uri = URI.parse(url)
		begin
			response_raw = Net::HTTP.get_response(uri)
			JsonSchemaValidator.valid? response_raw.body
			response = response_raw.body
		rescue TypeError, SocketError
			response = {"error" => "La dirección no es válida o no pertenece a un servidor de streaming IceCast."}
		rescue JSON::Schema::ValueError, JSON::ParserError
			response = {"error" => "Datos incorrectos. Por favor, compruebe que la URL del servidor IceCast es correcta."}
		end
		render :json => response
	end

end