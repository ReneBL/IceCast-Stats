var app = angular.module('icecastStats');

app.controller("HomeController", function($scope, $interval, StateFactory,
					 	IceCastServer, ServerStreamingDataParser) {
  $scope.intermitent = false;
	$scope.invalidData = false;
    var getData = function () {
        IceCastServer.get({url: StateFactory.getServer()}, function(datos) {
            if (validateDatos(datos)) {
                var result = ServerStreamingDataParser.fromJsonGetListeners(datos);
                var content = ServerStreamingDataParser.fromJsonGetContent(datos);
                processListeners(result);
                processContent(content);
            }
        });
    }
    getData();
	var poll = $interval(function () {
		getData();
	}, StateFactory.getRefreshSeconds());

    var intermitent = $interval(function () {
        $scope.intermitent = !$scope.intermitent;
    }, 1000);

	// Cuando se cambie de página, se emitirá un evento "destroy", lo capturaremos para cancelar el intervalo
	// establecido anteriormente, y también nos servirá para guardar los listeners que había antes
	$scope.$on('$destroy', function() {
        $interval.cancel(poll);
        $interval.cancel(intermitent);
    });

    var processListeners = function(result) {
		$scope.listeners = result;
    };

    var processContent = function(content) {
    	$scope.programa = content.playing;
    	$scope.genero = content.genre;
    	$scope.serverUrl = content.url;
			$scope.descripcion = content.desc;
			$scope.guid = content.guid;
			$scope.image = content.link;
    };

    var validateDatos = function(datos) {
    	$scope.invalidData = datos.hasOwnProperty("error");
    	$scope.message = (datos.error == undefined) ? "" : datos.error;
    	return (!$scope.invalidData);
    };

});

app.controller("LastXHoursController", function ($scope, $interval, Last24HoursDataProvider,
    Last24HoursOptionsProvider, LastConnections, StateFactory) {

    var initData = function () {
        LastConnections.query({}, function (datos) {
            $scope.dataEmpty = (datos.length == 0);
            if (!datos.length == 0) {
                $scope.options = Last24HoursOptionsProvider.provide();
                $scope.data = Last24HoursDataProvider.provide(datos);
            }
            $scope.loaded = !$scope.dataEmpty;
        });
    }
    initData();

    var pollXHours = $interval(function () {
        initData();
    }, StateFactory.getRefreshMinutes());

    $scope.$on('$destroy', function() {
        $interval.cancel(pollXHours);
    });
});
