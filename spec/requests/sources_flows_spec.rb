require 'rails_helper'

RSpec.describe "SourcesFlows", type: :request do

	# before(:each) do
	# 	unless !File.exists? "config/sources.txt"
	# 		File.delete "config/sources.txt"
	# 	end
	# 	f = File.new("config/sources.txt", "w+")
	# 	f << "cuacfm-128k.mp3\n"
	# 	f << "cuacfm.mp3\n"
	# 	f << "pepito.ogg\n"
	# 	# OJO : nunca cerrar el fichero porque nunca se podria volver a abrir desde codigo
	# 	f.flush

	# 	FactoryGirl.create(:source_cuacfm_128k)
 #      	FactoryGirl.create(:source_cuacfm_november)
 #      	FactoryGirl.create(:source_cuacfm_december)
 #      	FactoryGirl.create(:source_pepito)
 #      	admin = FactoryGirl.create(:admin)
 #      	#log_in(admin)
	# end

 # 	describe "when post to sources" do
	# 	it "should introduce the name of the source in session" do
 #      		connections_between_dates_year_array = [
 #        		{ :_id => { :year => 2013 }, :count => 4 }
 #      		]
 #      		expected = connections_between_dates_year_array.to_json

	# 		do_request expected
	# 		post :set_source, {:source => "cuacfm.mp3"}

	# 		connections_between_dates_year_array = [
 #        		{ :_id => { :year => 2013 }, :count => 2 }
 #      		]
 #      		expected2 = connections_between_dates_year_array.to_json
	# 		do_request expected2

	# 		post :set_source, {:source => "all"}
	# 		do_request expected
 #    	end
 #    	def do_request expected
	# 		xhr :get, "/connections/connections_between_dates", :start_date => '01/01/2010', :end_date => '01/01/2020', :group_by => 'year',
	# 			:unique_visitors => 'false'
 #     		#get_with_token "/connections/connections_between_dates", {:start_date => '01/01/2010', :end_date => '01/01/2020', :group_by => 'year', 
 #     			#:unique_visitors => 'false'}
 #     		#{:start_date => '01/01/2010', :end_date => '01/01/2020', :group_by => 'year', 
 #     		#	:unique_visitors => 'false'}
 #     		expect(response.body).to eql(expected)
	# 	end
	# 	def retrieve_access_token
 #    		post login_path(session: { login: "admin", password: "admin" })
 #    		follow_redirect!
 #    		#expect(response.response_code).to eq 201
 #    		#expect(response.body).to match(/"access_token":".{20}"/)
 #    		parsed = JSON(response.header)
 #    		parsed['_IceCast-Stats_session']
 #  		end
 #  		 def get_with_token(path, params={}, headers={})
 #    		headers.merge!('HTTP_ACCESS_TOKEN' => retrieve_access_token)
 #    		xhr :get, path, {:params => params}, headers
 #  		end

 #  		def post_with_token(path, params={}, headers={})
 #    		headers.merge!('HTTP_ACCESS_TOKEN' => retrieve_access_token)
 #    		xhr :post, path, params, headers
 #  		end
 #  	end
end	