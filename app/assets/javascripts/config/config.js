var app = angular.module('icecastStats');

app.controller('ConfigurationController', function ($scope, Sources, StateFactory, CONFIGURATION) {
	$scope.refreshSeconds = StateFactory.getRefreshSeconds() / 1000;
	$scope.server = StateFactory.getServer();

	Sources.query(function (data) {
		$scope.sources = data;
		$scope.sources.unshift(CONFIGURATION.DEFAULT_SOURCE);
		// Recuperamos el estado de la factoria e inicializamos el model
		$scope.source = StateFactory.getSelectedSource();
	});

	$scope.$watch("source", function(newValue, oldValue) {
			if(newValue != oldValue){
					Sources.save({source: newValue});
					// Guardamos el estado en la factoria
					StateFactory.setSelectedSource(newValue);
				}
		});

	$scope.setRefreshSeconds = function (validForm) {
		if (validForm) {
			var seconds = $scope.refreshSeconds * 1000;
			StateFactory.setRefreshSeconds(seconds);
		}
	};

	$scope.setServer = function (validForm) {
		if (validForm) {
			var server = $scope.server;
			StateFactory.setServer(server);
		}
	};
});