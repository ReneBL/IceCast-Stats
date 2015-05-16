var app = angular.module("icecastStats");

app.controller("RegionsCitiesConnectionsController", function ($scope, RegionsConnections, RegionsTotalTime, 
	CitiesConnections, CitiesTotalTime, Countries, Regions, RegionsCitiesDataProvider, RegionsCitiesOptionsProvider, 
	NotificationService, ISO3166) {

	$scope.dataType = 'numConnections';
	$scope.citiesCheckedModel = {
		checked : false
	}

	var getDataCountries = function() {
		Countries.query({}, function(datos) {
			$scope.countries = datos;
			$scope.country = datos[0];
			$scope.doGetData($scope.$parent.doGetParams(), RegionsConnections);
		});
	}
	getDataCountries();

	var getDataRegions = function() {
		Regions.query({country: $scope.country}, function(datos) {
			$scope.regions = datos;
			$scope.regionsEmpty = ($scope.regions.length == 0);
			if (!$scope.regionsEmpty) {
				$scope.region = datos[0];
				drawTypeOfChart($scope.dataType)
			}
		});
	}

	$scope.selectedCountry = function() {
		getDataRegions();
	}

	$scope.selectedCountryRegion = function() {
		drawTypeOfChart($scope.dataType);
	}

	$scope.changedCheckBoxCities = function() {
		$scope.citiesCheckedModel.checked ? getDataRegions() : drawTypeOfChart($scope.dataType);
	}

	$scope.doGetData = function(params, obj) {
		var cloneParams = angular.copy(params);
		cloneParams['country'] = $scope.country;
		if ($scope.citiesCheckedModel.checked) {
			cloneParams['region'] = $scope.region;
		}
		obj.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	    	$scope.data = RegionsCitiesDataProvider.provide(datos, $scope.dataType, $scope.citiesCheckedModel.checked);
	   	     	$scope.options = RegionsCitiesOptionsProvider.provide(ISO3166.getCountryCode($scope.country.toUpperCase()));
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	
	$scope.cleanContext = function() {
		$scope.data = null;
	   	$scope.options = null;
	   	$scope.loaded = false;
	};

	$scope.show = function(dataType) {
		if ($scope.dataType != dataType) {
			$scope.dataType = dataType;
			$scope.cleanContext();
			drawTypeOfChart(dataType);
		}
	};

	var drawTypeOfChart = function(dataType) {
		$scope.cleanContext();
		var temp = $scope.$parent.doGetParams();
		switch (dataType) {
			case "numConnections" : $scope.citiesCheckedModel.checked ? $scope.doGetData(temp, CitiesConnections) : $scope.doGetData(temp, RegionsConnections); 
									break;
							   // Adaptamos los parámetros del padre a los que recibe CountriesTotalTime (todos menos "unique_visitors")
			case "totalTime" :  delete temp.unique_visitors;
								$scope.citiesCheckedModel.checked ? $scope.doGetData(temp, CitiesTotalTime) : $scope.doGetData(temp, RegionsTotalTime);
								break;
		}
	};

	var refreshDataOnBroadCast = function(params) {
		var obj = ($scope.dataType == 'numConnections') ? RegionsConnections : RegionsTotalTime;
		$scope.cleanContext();
		$scope.doGetData(params, obj);
	};

	NotificationService.onChangeScope($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		// Si estamos viendo el tiempo total escuchado, no nos sirve de nada la opcion de agrupar visitantes unicos
		// por lo tanto cuando se emita el broadcast, no entraremos en la condición y no se actualizará la gráfica innecesariamente
		if ($scope.dataType != 'totalTime') {
			refreshDataOnBroadCast(message.params);
		}
	});
});

app.controller("CountriesConnectionsController", function ($scope, CountriesConnections, CountriesConnectionsDataProvider,
	CountriesConnectionsOptionsProvider, CountriesTotalTime, NotificationService) {

	$scope.dataType = 'numConnections';

	$scope.doGetData = function(params, obj) {
		var cloneParams = angular.copy(params);
		obj.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	    	$scope.data = CountriesConnectionsDataProvider.provide(datos, $scope.dataType);
	   	     	$scope.options = CountriesConnectionsOptionsProvider.provide();
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	// Para inicializar, llamamos a do get data con CountriesConnections, la opción por defecto
	$scope.data = $scope.doGetData($scope.$parent.doGetParams(), CountriesConnections);
	$scope.cleanContext = function() {
		$scope.data = null;
	   	$scope.options = null;
	   	$scope.loaded = false;
	};

	$scope.show = function(dataType) {
		if ($scope.dataType != dataType) {
			$scope.dataType = dataType;
			$scope.cleanContext();
			var temp = $scope.$parent.doGetParams();
			switch (dataType) {
				case "numConnections" : $scope.doGetData(temp, CountriesConnections);
										break;
								   // Adaptamos los parámetros del padre a los que recibe CountriesTotalTime (todos menos "unique_visitors")
				case "totalTime" :  delete temp.unique_visitors;
									$scope.doGetData(temp, CountriesTotalTime);
									break;
			}
		}
	};

	var refreshDataOnBroadCast = function(params) {
		var obj = ($scope.dataType == 'numConnections') ? CountriesConnections : CountriesTotalTime;
		$scope.cleanContext();
		$scope.doGetData(params, obj);
	};

	NotificationService.onChangeScope($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		// Si estamos viendo el tiempo total escuchado, no nos sirve de nada la opcion de agrupar visitantes unicos
		// por lo tanto cuando se emita el broadcast, no entraremos en la condición y no se actualizará la gráfica innecesariamente
		if ($scope.dataType != 'totalTime') {
			refreshDataOnBroadCast(message.params);
		}
	});
});