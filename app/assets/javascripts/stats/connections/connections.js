var app = angular.module('icecastStats');

app.controller("ProgramsController", function ($scope, Programs, NotificationService, ProgramsDataProvider,
	ProgramsOptionsProvider) {

	var refreshUniqueParam = function() {
		return ("true" === $scope.$parent.doGetParams().unique_visitors);
	}

	$scope.uniqueVisitors = refreshUniqueParam();

	$scope.doGetData = function(params) {
		var cloneParams = angular.copy(params);
		Programs.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	     	$scope.options = ProgramsOptionsProvider.provide($scope.uniqueVisitors);
	   	    	$scope.data = ProgramsDataProvider.provide(datos, $scope.uniqueVisitors);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	$scope.doGetData($scope.$parent.doGetParams());

	NotificationService.onChangeScope($scope, function(message) {
		$scope.doGetData(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		$scope.uniqueVisitors = refreshUniqueParam();
		$scope.doGetData(message.params);
	});

});

app.controller("TotalTimeController", function ($scope, TotalTime, SecondsConverter, NotificationService) {
	var refresh = function() {
		var params = $scope.$parent.doGetParams();
		delete params.unique_visitors;
		TotalTime.query(params, function (datos) {
			$scope.dataEmpty = (datos.length == 0);
			if (!$scope.dataEmpty) {
				var time = SecondsConverter.toHoursMinutesSeconds(datos[0].count);
				$scope.time = {
					hours: time.hours,
					minutes: time.minutes,
					seconds: time.seconds
				};
			}
		});
	};
	refresh();

	NotificationService.onChangeScope($scope, function(message) {
		refresh();
	});
});

app.controller("AvgTimeController", function ($scope, AvgTime, SecondsConverter, NotificationService) {
	var refresh = function() {
		var params = $scope.$parent.doGetParams();
		delete params.unique_visitors;
		AvgTime.query(params, function (datos) {
			$scope.dataEmpty = (datos.length == 0);
			if (!$scope.dataEmpty) {
				var time = SecondsConverter.toHoursMinutesSeconds(datos[0].count);
				$scope.time = {
					hours: time.hours,
					minutes: time.minutes,
					seconds: time.seconds
				};
			}
		});
	};
	refresh();

	NotificationService.onChangeScope($scope, function(message) {
		refresh();
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
	   	     	$scope.options = RangesOptionsProvider.provide();
	   	    	$scope.data = RangesDataProvider.provide(datos);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.doGetData($scope.$parent.doGetParams());
	var doRequest = function() {
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

	NotificationService.onChangeScope($scope, function(message) {
		$scope.doGetData(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		$scope.doGetData(message.params);
	});
});

app.controller('GroupedTotalSecondsChartController', function ($scope, GroupedTotalSeconds, NotificationService,
	GroupedChartDataProvider, GroupedTotalSecondsOptionsProvider, CONNECTIONS, GROUP_BY) {

	$scope.groupBy = GROUP_BY.YEAR;

	$scope.doGetData = function(params) {
		var cloneParams = angular.copy(params);
		cloneParams["group_by"] = $scope.groupBy;
		GroupedTotalSeconds.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	     	$scope.options = GroupedTotalSecondsOptionsProvider.provide($scope.groupBy);
	   	    	$scope.data = GroupedChartDataProvider.provide($scope.groupBy, datos, CONNECTIONS.TOTAL_SECONDS);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};

	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.doGetData($scope.$parent.doGetParams());

	$scope.group = function(value) {
		if($scope.groupBy != value) { 	 
	   		$scope.groupBy = value;
	   	    $scope.doGetData($scope.$parent.doGetParams());
	   	}
	};

	NotificationService.onChangeScope($scope, function(message) {
		$scope.doGetData(message.params);
	});
});

app.controller('ConnectionsGroupedChartController', function ($scope, ConnectionsBetweenDates, GroupedChartDataProvider,
	  ConnBetDatesOptionsProvider, NotificationService, CONNECTIONS, GROUP_BY) {

	$scope.groupBy = GROUP_BY.YEAR;

	$scope.doGetData = function(params) {
		var cloneParams = angular.copy(params);
		cloneParams["group_by"] = $scope.groupBy;
		ConnectionsBetweenDates.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	     	$scope.options = ConnBetDatesOptionsProvider.provide($scope.groupBy);
	   	    	$scope.data = GroupedChartDataProvider.provide($scope.groupBy, datos, CONNECTIONS.TOTAL_LISTENERS);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};

	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.doGetData($scope.$parent.doGetParams());
   
	$scope.group = function(value) {
		if($scope.groupBy != value) { 	 
	   		$scope.groupBy = value;
	   	    $scope.doGetData($scope.$parent.doGetParams());
	   	}
	};

	NotificationService.onChangeScope($scope, function(message) {
		$scope.doGetData(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		$scope.doGetData(message.params);
	});
});
