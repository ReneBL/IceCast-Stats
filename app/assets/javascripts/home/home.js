var app = angular.module('icecastStats');

app.controller("HomeController", function($scope, $interval, StateFactory,
					 	IceCastServer, ServerStreamingDataParser) {
	$scope.listeners = StateFactory.getListeners();
	$scope.invalidData = false;
	var poll = $interval(function () {
		IceCastServer.get({url: StateFactory.getServer()}, function(datos) {
			var result = ServerStreamingDataParser.fromJsonGetListeners(datos);
			if (isNaN(result)) {
				$scope.message = result;
				$scope.invalidData = true;
			} else {
				$scope.listeners = result;
				$scope.invalidData = false;
			} 
		});
	}, StateFactory.getRefreshSeconds());
	// Cuando se cambie de página, se emitirá un evento "destroy", lo capturaremos para cancelar el intervalo
	// establecido anteriormente, y también nos servirá para guardar los listeners que había antes
	$scope.$on('$destroy', function() {
        $interval.cancel(poll);
        StateFactory.setListeners($scope.listeners);
    });
});