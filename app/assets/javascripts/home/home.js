var app = angular.module('icecastStats');

app.controller("HomeController", function($scope, $interval, StateFactory,
					 	IceCastServer, ServerStreamingDataParser) {
    $scope.intermitent = false;
	$scope.listeners = StateFactory.getListeners();
	$scope.invalidData = false;
	var poll = $interval(function () {
		IceCastServer.get({url: StateFactory.getServer()}, function(datos) {
			if (validateDatos(datos)) {
				var result = ServerStreamingDataParser.fromJsonGetListeners(datos);
				var content = ServerStreamingDataParser.fromJsonGetContent(datos);
				processListeners(result);
				processContent(content);
			}
		});
	}, StateFactory.getRefreshSeconds());
    var intermitent = $interval(function () {
        $scope.intermitent = !$scope.intermitent;
    }, 1000);

	// Cuando se cambie de página, se emitirá un evento "destroy", lo capturaremos para cancelar el intervalo
	// establecido anteriormente, y también nos servirá para guardar los listeners que había antes
	$scope.$on('$destroy', function() {
        $interval.cancel(poll);
        $interval.cancel(intermitent);
        StateFactory.setListeners($scope.listeners);
    });

    var processListeners = function(result) {
		$scope.listeners = result;
    };

    var processContent = function(content) {
    	$scope.programa = content.playing;
    	$scope.genero = content.genre;
    	$scope.serverUrl = content.url;
    };

    var validateDatos = function(datos) {
    	$scope.invalidData = datos.hasOwnProperty("error");
    	$scope.message = (datos.error == undefined) ? "" : datos.error;
    	return (!$scope.invalidData);
    };

});