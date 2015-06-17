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

FactoryGirl.define do
	factory :sin_etiquetas_start, class: Program do
		name 'Sin Etiquetas'
		seconds_listened 60
	end

	factory :sin_etiquetas, class: Program do
		name 'Sin Etiquetas'
		seconds_listened 1800 # 30 minutos
	end

	factory :fantasma_accidental, class: Program do
		name 'Fantasma accidental'
		seconds_listened 1800 # 30 minutos
	end

	factory :la_enredadera, class: Program do
		name 'La enredadera'
		seconds_listened 3000 # 50 minutos
	end

	factory :folk_in_trio_start, class: Program do
		name 'Folk in trio'
		seconds_listened 600 # 10 minutos
	end

	factory :folk_in_trio, class: Program do
		name 'Folk in trio'
		seconds_listened 3000
	end

	factory :el_rinconcito, class: Program do
		name 'El Rinconcito'
		seconds_listened 3600 # 50 minutos
	end

	factory :listening_sin_etiquetas, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-04-30 22:00:00 UTC' # => 22:00:00 UTC = 00:00:00 GMT + 0200
		request 'GET /cuacfm.mp3 HTTP/1.1'
		status 200
		bytes 1000
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 60
		programs {[FactoryGirl.build(:sin_etiquetas_start)]}
	end

	factory :listening_sin_etiquetas_fantasma_accidental, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-04-30 23:30:00 UTC' # => 22:00:00 UTC = 00:00:00 GMT + 0200
		request 'GET /cuacfm.mp3 HTTP/1.1'
		status 200
		bytes 1000
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 3600
		programs {[FactoryGirl.build(:sin_etiquetas), FactoryGirl.build(:fantasma_accidental)]}
	end

	factory :listening_la_enredadera, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-05-01 00:00:00 UTC'
		request 'GET /cuacfm.mp3 HTTP/1.1'
		status 200
		bytes 11111
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 3000
		programs {[FactoryGirl.build(:la_enredadera)]}
	end

	factory :listening_FolkInTrio_ElRinconcito, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-05-01 21:10:00 UTC'
		request 'GET /cuacfm-128k.mp3 HTTP/1.1'
		status 200
		bytes 115396
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 4200 # Una hora
		programs {[FactoryGirl.build(:el_rinconcito), FactoryGirl.build(:folk_in_trio_start)]}
	end

	factory :listening_FolkInTrio, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-05-01 22:00:00 UTC'
		request 'GET /cuacfm.aac HTTP/1.1'
		status 200
		bytes 115396
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 3000
		programs {[FactoryGirl.build(:folk_in_trio)]}
	end

	# Esta conexión no tendrá info de programas, está fuera de la programación
	factory :connection_out_of_24_hours_before, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-03-31 08:10:00 UTC'
		request 'GET /cuacfm.mp3 HTTP/1.1'
		status 200
		bytes 115396
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 2400 # 40 minutos
		programs {[]}
	end

	factory :connection_out_of_24_hours_after, class: Connection do
		ip '78.46.19.144'
		identd '-'
		userid '-'
		datetime '2015-05-02 10:10:00 UTC'
		request 'GET /filispin.mp3 HTTP/1.1'
		status 200
		bytes 115396
		referrer '-'
		user_agent 'iTunes/9.1.1'
		seconds_connected 600
		programs {[]}
	end
end