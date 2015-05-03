var app = angular.module('icecastStats');

app.controller("HomeController", function($scope, $interval, StateFactory,
					 	IceCastServer, ServerStreamingDataParser) {
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
	// Cuando se cambie de página, se emitirá un evento "destroy", lo capturaremos para cancelar el intervalo
	// establecido anteriormente, y también nos servirá para guardar los listeners que había antes
	$scope.$on('$destroy', function() {
        $interval.cancel(poll);
        StateFactory.setListeners($scope.listeners);
    });

    var processListeners = function(result) {
		$scope.listeners = result;
    };

    var processContent = function(content) {
    	$scope.programa = content.playing;
    	$scope.genero = content.genre;
    	$scope.serverUrl = content.url;
    	obj = createSongObject();
    	initializePlayer(obj);
    };

    var validateDatos = function(datos) {
    	$scope.invalidData = datos.hasOwnProperty("error");
    	$scope.message = (datos.error == undefined) ? "" : datos.error;
    	return (!$scope.invalidData);
    };

    var createSongObject = function() {
    	var obj = {
    	"volume": .35,
        "songs": [
            {
                "name": $scope.programa,
                "artist": $scope.genero,
                "url": $scope.serverUrl
            }
        ],
        "default_album_art": "/assets/cuac.jpg"
    	};
    	return obj;
    };

    var initializePlayer = function(obj) {
    	Amplitude.init(obj);
    };

});