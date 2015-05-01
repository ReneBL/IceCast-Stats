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

	return {
		fromJsonGetListeners: fromJsonGetListeners
	}

});