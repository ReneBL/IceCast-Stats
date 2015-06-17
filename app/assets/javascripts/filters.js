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