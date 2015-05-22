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