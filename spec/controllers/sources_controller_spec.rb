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

require 'rails_helper'

RSpec.describe SourcesController, type: :controller do

	before(:each) do
		unless !File.exists? "config/sources.txt"
			File.delete "config/sources.txt"
		end
		f = File.new("config/sources.txt", "w+")
		f << "cuacfm-128k.mp3\n"
		f << "cuacfm.mp3\n"
		f << "pepito.ogg\n"
		f << "pepito.ogg\n"
		f << "cuacfm.mp3\n"
		f << "cuacfm.mp3\n"
		# OJO : nunca cerrar el fichero porque nunca se podria volver a abrir desde codigo
		f.flush
		admin = FactoryGirl.create(:admin)
      	log_in(admin)

	end

	describe "when gets sources" do
		it "should return a list of available sources" do
			array_sources = ["cuacfm-128k.mp3", "cuacfm.mp3", "pepito.ogg"]
			expected = array_sources.to_json
			xhr :get, :get_sources, :format => :json
    		expect(response.body).to eql(expected)
		end
	end

	describe "when post to sources" do
		it "should introduce the name of the source in session" do	
			assert session[:source] == nil
			post :set_source, {:source => "cuacfm.mp3"}
			expect(response.body).to eql({"source" => "cuacfm.mp3"}.to_json)
			assert session[:source] == "cuacfm.mp3"

			post :set_source, {:source => DEFAULT_SOURCE}
			expect(response.body).to eql({"source" => "Todos"}.to_json)
			assert session[:source] == nil
		end

		it "should return error" do
			assert session[:source] == nil
			post :set_source, {:source => "nonexistentsource.mp3"}
			expect(response.body).to eql({"source" => "does not exists"}.to_json)
			assert session[:source] == nil
		end
	end
end