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