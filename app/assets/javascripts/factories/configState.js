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

	var getListeners = function () {
		return this.listeners;
	}

	var setListeners = function(listeners) {
		this.listeners = listeners;
	}

	return {
		source: CONFIGURATION.DEFAULT_SOURCE,
		refreshSeconds: 5000,
		server: CONFIGURATION.DEFAULT_POLL_URL,
		listeners: 0,
		getSelectedSource: getSource,
		setSelectedSource: setSource,
		getRefreshSeconds: getSeconds,
		setRefreshSeconds: setSeconds,
		getServer: getServer,
		setServer: setServer,
		getListeners: getListeners,
		setListeners: setListeners
	};
});