class SourcesController < ApplicationController
	before_action :check_params, only: [:set_source] 

	def get_sources
		sources = sources_file_lines
		render :json => sources.to_json
	end

	def set_source
		source = params[:source]
		default_source = (source.eql? DEFAULT_SOURCE)
		if default_source
			session[:source] = nil
		elsif (sources_file_lines.include? source)
			session[:source] = source
		else 
			render :json => {"source" => "does not exists"}.to_json
			return
		end
		render :json => {"source" => source}.to_json
	end

	private

	def check_params
		params.require(:source)
	end

	def sources_file_lines
		config = YAML.load_file('config/sources_config.yml')
		f = File.open(config['source_file_path'], "r+")
		sources = f.readlines.uniq
		# Recorremos y modificamos cada linea del fichero con collect! para eliminar saltos de linea, con chomp
		sources.collect! do |line|
			line.chomp
		end
		sources
	end

end