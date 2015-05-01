var app = angular.module('icecastStats');

app.controller('StatsController', function($scope, StateFactory) {
	  $scope.page = 'stats/connections/_connections.html';
	  $scope.selectedOption = 'conexiones';
	  
	  $scope.clickConexiones = function () {
	  	  $scope.page = 'stats/connections/_connections.html';
	  	  $scope.selectedOption = 'conexiones';
	  };
	  
	  $scope.clickLocalizaciones = function () {
	  	  $scope.page = 'stats/geolocation/_locations.html';
	  	  $scope.selectedOption = 'localizaciones';
	  };
	  
	  $scope.clickPaginas = function () {
	  	  $scope.page = 'stats/pages/_pages.html';
	  	  $scope.selectedOption = 'paginas';
	  };
	  // Obtenemos el source actual de la factoria que contiene el estado
	  $scope.source = StateFactory.getSelectedSource();
	  
});

app.controller("FilterController", function($scope, $filter, NotificationService) {
	var fechaActual = new Date();
	$scope.fechaInicio = fechaActual;
	$scope.fechaFin = fechaActual;
	var inicioDia = new Date(1970, 0, 1, 00, 00, 00, 0);
	var finDia = new Date(1970, 0, 1, 23, 59, 59, 0);
	$scope.horaInicio = inicioDia;
	$scope.horaFin = finDia;
	$scope.showHourRange = false;
	$scope.validHoursForm = true;
	$scope.unique = false;
	$scope.invalid = false;

	$scope.doGetParams = function() {
		var params = {start_date : $filter('date')($scope.fechaInicio, 'dd/MM/yyyy'), 
	   	     end_date : $filter('date')($scope.fechaFin, 'dd/MM/yyyy'), unique_visitors : $scope.unique.toString()};

	   	// Solo si el checkbox está activado y las horas son validas las añadimos como parametros
	   	// validHoursForm se seteará a true cuando haya un cambio en la hora inicio o fin y el formulario que las engloba
	   	// es correcto. Es decir, si hora inicio y hora fin son correctas
	   	if ($scope.showHourRange && $scope.validHoursForm) {
	   		params["start_hour"] = formatDateToString($scope.horaInicio);
	   		params["end_hour"] = formatDateToString($scope.horaFin);
	   	}
	   	return params;
	};

	var sendBroadcast = function() {
		var data = $scope.doGetParams();
   		NotificationService.sendScopeChanged(data);
	};

   	$scope.changedCheckBoxUniqueVisitors = function() {
   		// Antes de realizar la peticion, comprobamos si las fechas son validas
		if(!$scope.invalid) {
			sendBroadcast();
   		}
   	};

	$scope.changedHour = function(validForm) {
	   	$scope.startNotLesserEnd = ($scope.horaInicio > $scope.horaFin); 
	   	$scope.validHoursForm = validForm;
	   	if ($scope.validHoursForm && !$scope.startNotLesserEnd) {
	   		sendBroadcast();
		}
	};

	$scope.changedDate = function() {
		$scope.invalid = ($scope.fechaFin < $scope.fechaInicio); 
		if (!$scope.invalid) {
	   		sendBroadcast();
	   	}
	};
	formatDateToString = function(date) {
		// Concatenamos un "0" al principio junto con slice para, en el caso de tener una hora, minuto o segundo de una sola cifra, convertirlo
	   	// en el formato HH:MM:SS (2 cifras cada uno)
		return ("0" + (date.getHours())).slice(-2) + ":" + ("0" + (date.getMinutes())).slice(-2) + ":" + ("0" + (date.getSeconds())).slice(-2)
	};

	$scope.changedCheckBoxHourRange = function() {
	   	// Si la hora inicio y al checkear y descheckear son iguales que el inicio y final de un dia, respectivamente, no
	   	// es necesario realizar de nuevo otra petición
	   	if (!(($scope.horaInicio == inicioDia) && ($scope.horaFin == finDia))) {
	   		sendBroadcast();
	   	}
	}

});
