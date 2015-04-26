class SourcesController < ApplicationController
	before_action :check_params, only: [:set_source] 

	def get_sources
		sources = sources_file_lines
		render :json => sources.to_json
	end

	def set_source
		source = params[:source]
		unless (!source.eql? "Todos")
			session[:source] = nil
		end
		if (sources_file_lines.include? source)
			session[:source] = source
			render :json => {"source" => source}.to_json
		else
			render :json => {"source" => "does not exist"}.to_json
		end
	end

	private

	def check_params
		params.require(:source)
	end

	def sources_file_lines
		config = YAML.load_file('config/sources_config.yml')
		f = File.open(config['source_file_path'], "r+")
		sources = f.readlines
		# Recorremos y modificamos cada linea del fichero con collect! para eliminar saltos de linea, con chomp
		sources.collect! do |line|
			line.chomp
		end
		sources
	end

end