var app = angular.module('icecastStats');
app.controller('YearsConnectionsController', function ($scope, YearsConnections) {  

});

app.controller('YearsController', function($scope, Years) {
	//Inyectamos los servicios RESTFul implementados con $resource
	  $scope.data = Years.query(function (data) {
    	$scope.years = data;
    	$scope.year = data[0];
	  });
});

app.controller('RangesController', function ($scope, Ranges, RangesDataProvider, RangesOptionsProvider, NotificationService) {
	var minRange = 5;
	var maxRange = 120;
	$scope.range = {
    	min: minRange,
    	max: maxRange
	};
	$scope.doGetData = function(params) {
		var cloneParams = angular.copy(params);
		cloneParams["max"] = $scope.range.max;
		cloneParams["min"] = $scope.range.min;
		Ranges.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	    	$scope.data = RangesDataProvider.provide(datos);
	   	     	$scope.options = RangesOptionsProvider.provide();
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.data = $scope.doGetData($scope.$parent.doGetParams());
	$scope.cleanContext = function() {
		$scope.data = null;
	   	$scope.options = null;
	   	$scope.loaded = false;
	};
	var doRequest = function() {
		$scope.cleanContext();
		$scope.doGetData($scope.$parent.doGetParams());
	};

	$scope.validateMin = function(validForm) {
		if (validForm) {
			$scope.minGreaterThanMax = ($scope.range.min > $scope.range.max);
			if (!$scope.minGreaterThanMax) {
				doRequest();
			}
		};
	};

	$scope.validateMax = function(validForm) {
		if (validForm) {
			$scope.maxGreaterThanMin = ($scope.range.max < $scope.range.min);
			if (!$scope.maxGreaterThanMin) {
				doRequest();
			}
		}
	};

	var refreshDataOnBroadCast = function(params) {
		$scope.cleanContext();
		$scope.doGetData(params);
	};

	NotificationService.onChangeScope($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});
});

app.controller('ConnectionsGroupedChartController', function ($scope, ConnectionsBetweenDates, ConnBetDatesDataProvider,
	  ConnBetDatesOptionsProvider, NotificationService) {

	$scope.groupBy = 'year';

	$scope.doGetData = function(params) {
		var cloneParams = angular.copy(params);
		cloneParams["group_by"] = $scope.groupBy;
		ConnectionsBetweenDates.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	    	$scope.data = ConnBetDatesDataProvider.provide($scope.groupBy, datos);
	   	     	$scope.options = ConnBetDatesOptionsProvider.provide($scope.groupBy);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};

	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.data = $scope.doGetData($scope.$parent.doGetParams());
   
	$scope.group = function(value) {
		if($scope.groupBy != value) { 	 
			$scope.cleanContext(); 
	   		$scope.groupBy = value;
	   	    $scope.doGetData($scope.$parent.doGetParams());
	   	}
	};
	   
	$scope.cleanContext = function() {
		$scope.data = null;
	   	$scope.options = null;
	   	$scope.loaded = false;
	};

	var refreshDataOnBroadCast = function(params) {
		$scope.cleanContext();
		$scope.doGetData(params);
	};

	NotificationService.onChangeScope($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});
});
