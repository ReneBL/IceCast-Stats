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

var module = angular.module("configState", []);

module.factory("StateFactory", function (CONFIGURATION) {
	var getSource = function() {
		return this.source;
	}

	var setSource = function(source) {
		this.source = source;
	};

	var getSeconds = function() {
		return this.refreshSeconds;
	}

	var setSeconds = function (seconds) {
		this.refreshSeconds = seconds;
	}

	var getServer = function() {
		return this.server;
	}

	var setServer = function (server) {
		this.server = server;
	}

	var getMinutes = function () {
		return this.minutes;
	}

	var setMinutes = function(minutes) {
		this.minutes = minutes;
	}

	return {
		source: CONFIGURATION.DEFAULT_SOURCE,
		refreshSeconds: CONFIGURATION.DEFAULT_REFRESH_SECONDS,
		minutes: CONFIGURATION.DEFAULT_REFRESH_MINUTES,
		server: CONFIGURATION.DEFAULT_POLL_URL,
		getSelectedSource: getSource,
		setSelectedSource: setSource,
		getRefreshSeconds: getSeconds,
		setRefreshSeconds: setSeconds,
		getServer: getServer,
		setServer: setServer,
		getRefreshMinutes: getMinutes,
		setRefreshMinutes: setMinutes
	};
});