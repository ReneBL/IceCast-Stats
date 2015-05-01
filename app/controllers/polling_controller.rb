require 'net/http'

class PollingController < ApplicationController

	def poll
		url = params[:route]
		#debugger
		uri = URI.parse(url)
		begin
			response_raw = Net::HTTP.get_response(uri)
			JsonSchemaValidator.valid? response_raw.body
			response = response_raw.body
		rescue TypeError
			response = {"error" => "No existen datos. Por favor, compruebe que la URL del servidor IceCast es correcta."}
		rescue JSON::Schema::ValueError, JSON::ParserError
			response = {"error" => "Datos incorrectos. Por favor, compruebe que la URL del servidor IceCast es correcta."}
		end
		render :json => response
	end

end