var app = angular.module('timeFactory', []);

app.factory("SecondsConverter", function () {

	var toHoursMinutesSeconds = function (seconds) {
		var hours = Math.floor(seconds / (60 * 60));
		var divisor_for_minutes = seconds % (60 * 60);
    	var minutes = Math.floor(divisor_for_minutes / 60);
    	var divisor_for_seconds = divisor_for_minutes % 60;
    	var seconds = Math.ceil(divisor_for_seconds);

    	var obj = {hours: hours, minutes: minutes, seconds: seconds};

    	return obj; 
	};

	return {
		toHoursMinutesSeconds: toHoursMinutesSeconds
	}
});