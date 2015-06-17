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
require 'spec_helper'
require "#{Rails.root}/lib/parser_rt"
require "#{Rails.root}/lib/database"

feature "poll with real time parser to IceCast" do

	background do
		Database.initialize_db
		ParserRT.initialize_parser
	end

	it "should return actual playing content stubbed" do
		# Hacemos un stub de la llamada
		stub_request(:get, "http://streaming.cuacfm.org/status-json.xsl").
     to_return(:body => '
     	{"icestats":
	{
		"admin":"tecnologia@cuacfm.org",
		"host":"streaming.cuacfm.org",
		"location":"ES",
		"server_id":"Icecast 2.4.0",
		"server_start":"Wed, 20 May 2015 02:07:48 +0200",
		"server_start_iso8601":"2015-05-20T02:07:48+0200",
		"source":[
			{"bitrate":128,"genre":"Radio","listener_peak":14,"listeners":3,
				"listenurl":"http://streaming.cuacfm.org:80/cuacfm-128k.mp3",
				"server_description":"CUAC FM - 103.4 FM - A radio comunitaria da Coruña (128kbps)",
				"server_name":"CUAC FM - 103.4 FM (MP3 Alta Calidade)","server_type":"audio/mpeg",
				"server_url":"http://www.cuacfm.org","stream_start":"Wed, 20 May 2015 02:07:48 +0200",
				"stream_start_iso8601":"2015-05-20T02:07:48+0200","title":"Cuac esta a pasar",
				"yp_currently_playing":"Cuac esta a pasar"},
			{"bitrate":128,"genre":"Radio","listener_peak":1,"listeners":0,
				"listenurl":"http://streaming.cuacfm.org:80/cuacfm.aac",
				"server_description":"CUAC FM - 103.4 FM - A radio comunitaria da Coruña (128kbps)",
				"server_name":"CUAC FM - 103.4 FM (AAC)","server_type":"audio/aac","server_url":"http://www.cuacfm.org",
				"stream_start":"Wed, 20 May 2015 02:07:48 +0200","stream_start_iso8601":"2015-05-20T02:07:48+0200",
				"title":"Cuac esta a pasar","yp_currently_playing":"Cuac esta a pasar"},
			{"bitrate":64,"genre":"Radio",
				"listener_peak":11,"listeners":2,"listenurl":"http://streaming.cuacfm.org:80/cuacfm.mp3",
				"server_description":"CUAC FM - 103.4 FM - A radio comunitaria da Coruña (64kbps)",
				"server_name":"CUAC FM - 103.4 FM","server_type":"audio/mpeg","server_url":"http://www.cuacfm.org",
				"stream_start":"Wed, 20 May 2015 02:07:48 +0200","stream_start_iso8601":"2015-05-20T02:07:48+0200",
				"title":"Cuac esta a pasar","yp_currently_playing":"Cuac esta a pasar"},
			{"audio_bitrate":96000,
				"audio_channels":2,"audio_samplerate":44100,"bitrate":96,"genre":"Radio","ice-bitrate":96,"listener_peak":4,
				"listeners":1,"listenurl":"http://streaming.cuacfm.org:80/cuacfm.ogg",
				"server_description":"CUAC FM - 103.4 FM - A radio comunitaria da Coruña (96kbps)",
				"server_name":"CUAC FM - 103.4 FM (OGG)","server_type":"application/ogg","server_url":"http://www.cuacfm.org",
				"stream_start":"Wed, 20 May 2015 02:07:49 +0200","stream_start_iso8601":"2015-05-20T02:07:49+0200",
				"subtype":"Vorbis","title":"Cuac esta a pasar","yp_currently_playing":"Cuac esta a pasar"
			}
		]
	}
}')
		# En este punto, el parser hará una request a una URL contenida en un fichero de configuración
		# que representa la dirección del servidor IceCast pero que será interceptada y servida por el stub con el
		# JSON representado arriba
		ParserRT.parse
		expect(WebMock).to have_requested(:get, "http://streaming.cuacfm.org/status-json.xsl")
		WebMock.reset!
		coll = Database.getRealTimeCollection
		result = coll.find.to_a
		expect(result.count).to eq(1)
		expect(result[0]["listeners"]).to eq(6)
	end
end
