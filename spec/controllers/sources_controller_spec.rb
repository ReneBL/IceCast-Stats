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
			assert session[:source] == "cuacfm.mp3"
		end

	end

end