var app = angular.module("icecastStats");

app.controller("RegionsCitiesConnectionsController", function ($scope, RegionsConnections, RegionsTotalTime,
	CitiesConnections, CitiesTotalTime, Countries, Regions, RegionsCitiesDataProvider, RegionsCitiesOptionsProvider,
	NotificationService, ISO3166, CONNECTIONS) {

	$scope.dataType = CONNECTIONS.TOTAL_LISTENERS;
	$scope.citiesCheckedModel = {
		checked : false
	}

	var getIndexOfActualCountryFromArray = function(countryArray) {
		var locales = navigator.languages;
		var localeSplit = locales[0].split("-");
		// Si la posicion 1 del array (la que representa el país del locale) es undefined, tomamos como país de origen
		// la posición 0, que representa al idioma
		var countryCode = (localeSplit[1] != undefined) ? localeSplit[1] : localeSplit[0].toUpperCase();
		if (ISO3166.isCountryCode(countryCode)) {
			var countryName = ISO3166.getCountryName(countryCode, 'toLowerCase');
			for (var i = 0; i < countryArray.length; i++) {
				if (countryArray[i].toLowerCase().localeCompare(countryName) == 0) {
					return i;
				}
			}
			return countryArray.indexOf(countryName);
		} else {
				return 0;
		}
	}

	var getDataCountries = function() {
		Countries.query({}, function(datos) {
			$scope.countries = datos;
			$scope.country = datos[getIndexOfActualCountryFromArray(datos)];
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
				drawTypeOfChart();
			}
		});
	}

	$scope.selectedCountry = function() {
		getDataRegions();
	}

	$scope.selectedRegion = function() {
		drawTypeOfChart();
	}

	$scope.changedCheckBoxCities = function() {
		$scope.citiesCheckedModel.checked ? getDataRegions() : drawTypeOfChart();
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
	   	     	$scope.options = RegionsCitiesOptionsProvider.provide(ISO3166.getCountryCode($scope.country.toUpperCase()));
	   	    	$scope.data = RegionsCitiesDataProvider.provide(datos, $scope.dataType, $scope.citiesCheckedModel.checked);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};

	$scope.show = function(dataType) {
		if ($scope.dataType != dataType) {
			$scope.dataType = dataType;
			drawTypeOfChart();
		}
	};

	var getTypeOfChart = function() {
		var obj;
		switch ($scope.dataType) {
			case CONNECTIONS.TOTAL_LISTENERS : obj = $scope.citiesCheckedModel.checked ? CitiesConnections :
														RegionsConnections;
											   break;
			case CONNECTIONS.TOTAL_SECONDS :  obj = $scope.citiesCheckedModel.checked ? CitiesTotalTime :
														RegionsTotalTime;
											  break;
		}
		return obj;
	}

	var drawTypeOfChart = function() {
		var temp = $scope.$parent.doGetParams();
		if ($scope.dataType == CONNECTIONS.TOTAL_SECONDS) {
			delete temp.unique_visitors;
		}
		obj = getTypeOfChart();
		$scope.doGetData(temp, obj);
	};

	NotificationService.onChangeScope($scope, function(message) {
		drawTypeOfChart();
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		// Si estamos viendo el tiempo total escuchado, no nos sirve de nada la opcion de agrupar visitantes unicos
		// por lo tanto cuando se emita el broadcast, no entraremos en la condición y no se actualizará la gráfica innecesariamente
		if ($scope.dataType != CONNECTIONS.TOTAL_SECONDS) {
			drawTypeOfChart();
		}
	});
});

app.controller("CountriesConnectionsController", function ($scope, CountriesConnections, CountriesConnectionsDataProvider,
	CountriesConnectionsOptionsProvider, CountriesTotalTime, NotificationService, CONNECTIONS) {

	$scope.dataType = CONNECTIONS.TOTAL_LISTENERS;

	$scope.doGetData = function(params, obj) {
		var cloneParams = angular.copy(params);
		obj.query(cloneParams, function(datos) {
	   		$scope.dataEmpty = datos.length == 0;
	   		if (!$scope.dataEmpty) {
	   	     	$scope.options = CountriesConnectionsOptionsProvider.provide();
	   	    	$scope.data = CountriesConnectionsDataProvider.provide(datos, $scope.dataType);
	    	}
	        $scope.loaded = !$scope.dataEmpty;
		});
	};
	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	// Para inicializar, llamamos a do get data con CountriesConnections, la opción por defecto
	$scope.doGetData($scope.$parent.doGetParams(), CountriesConnections);

	$scope.show = function(dataType) {
		if ($scope.dataType != dataType) {
			$scope.dataType = dataType;
			var temp = $scope.$parent.doGetParams();
			switch (dataType) {
				case CONNECTIONS.TOTAL_LISTENERS : $scope.doGetData(temp, CountriesConnections);
												   break;
								   				  /* Adaptamos los parámetros del padre a los que recibe
								   				  CountriesTotalTime (todos menos "unique_visitors")*/
				case CONNECTIONS.TOTAL_SECONDS :  delete temp.unique_visitors;
												  $scope.doGetData(temp, CountriesTotalTime);
												  break;
			}
		}
	};

	var refreshDataOnBroadCast = function(params) {
		var obj = ($scope.dataType == CONNECTIONS.TOTAL_LISTENERS) ? CountriesConnections : CountriesTotalTime;
		$scope.doGetData(params, obj);
	};

	NotificationService.onChangeScope($scope, function(message) {
		refreshDataOnBroadCast(message.params);
	});

	NotificationService.onUniqueChanged($scope, function(message) {
		// Si estamos viendo el tiempo total escuchado, no nos sirve de nada la opcion de agrupar visitantes unicos
		// por lo tanto cuando se emita el broadcast, no entraremos en la condición y no se actualizará la gráfica innecesariamente
		if ($scope.dataType != CONNECTIONS.TOTAL_SECONDS) {
			refreshDataOnBroadCast(message.params);
		}
	});
});
