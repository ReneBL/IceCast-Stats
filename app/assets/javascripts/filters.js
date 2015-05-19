var module = angular.module("filters", ['timeFactory']);

module.filter("bytesFilter", function() {
	return function (input, decimals) {
   		if (input == 0) return '0 Bytes';
   		var k = 1000;
   		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
   		var i = Math.floor(Math.log(input) / Math.log(k));
   		return (input / Math.pow(k, i)).toPrecision(decimals + 1) + ' ' + sizes[i];
	}
});

module.filter("secondsFilter", function (SecondsConverter) {
	return function (input) {
		return SecondsConverter.toStringSeconds(input);
	}
});