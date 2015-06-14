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
