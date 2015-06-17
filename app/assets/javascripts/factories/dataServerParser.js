/**********************************************************************************
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
**********************************************************************************/

var app = angular.module("dataServerParser", []);

app.factory("ServerStreamingDataParser", function() {

	var fromJsonGetListeners = function (jsonData) {
		var object = jsonData;
		if (object.hasOwnProperty("error")) {
			return object.error
		} else {
			var sources = object.icestats.source;
			var listeners = 0;
			for (var i = 0; i < sources.length; i++) {
				listeners += sources[i].listeners;
			}
			return listeners
		}
	}

	var fromJsonGetCurrentContent = function(jsonData) {
		var object = jsonData;
		if (object.hasOwnProperty("error")) {
			return object
		} else {
			var sources = object.icestats.source;
			var playing = sources[0].yp_currently_playing;
			var genre = sources[0].genre;
			var url = sources[0].listenurl;
			var desc = object.description;
			var guid = object.guid;
			var link = object.link;
			return {playing: playing, genre: genre, url: url, desc: desc, guid: guid, link: link};
		}
	}

	return {
		fromJsonGetListeners: fromJsonGetListeners,
		fromJsonGetContent: fromJsonGetCurrentContent
	}

});
