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

	var toString = function(seconds) {
		var hms = toHoursMinutesSeconds(seconds);
		return hms.hours + 'h : ' + hms.minutes + 'm : ' + hms.seconds + 's'
	}

	return {
		toHoursMinutesSeconds: toHoursMinutesSeconds,
		toStringSeconds: toString
	}
});