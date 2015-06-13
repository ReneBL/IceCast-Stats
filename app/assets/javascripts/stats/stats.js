var app = angular.module('icecastStats');

app.controller('StatsController', function($scope) {
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
	  
	  $scope.clickRankings = function () {
	  	  $scope.page = 'stats/rankings/_rankings.html';
	  	  $scope.selectedOption = 'rankings';
	  };
});

app.controller("FilterController", function($scope, $filter, StateFactory, NotificationService) {
	var fechaActual = new Date();
	$scope.fechaInicio = fechaActual;
	$scope.fechaFin = fechaActual;
	var inicioDia = new Date(1970, 0, 1, 00, 00, 00, 0);
	var finDia = new Date(1970, 0, 1, 23, 59, 59, 0);
	$scope.horaInicio = inicioDia;
	$scope.horaFin = finDia;
	$scope.showHourRange = false;
	$scope.validFormWhenHoursActived = true;
	$scope.unique = false;
	$scope.dates = {
		consistent : false
	};
	// Obtenemos el source actual de la factoria que contiene el estado
	$scope.source = StateFactory.getSelectedSource();

	$scope.doGetParams = function() {
		var params = {start_date : $filter('date')($scope.fechaInicio, 'dd/MM/yyyy'), 
	   	     end_date : $filter('date')($scope.fechaFin, 'dd/MM/yyyy'), unique_visitors : $scope.unique.toString()};

	   	// Solo si el checkbox está activado y las horas son validas las añadimos como parametros
	   	// validFormWhenHoursActived se seteará a true cuando haya un cambio en la hora inicio o fin y el formulario que las engloba
	   	// es correcto. Es decir, si hora inicio y hora fin son correctas. Es una "foto" de la validez en el último instante en que quedaron las horas
	   	// inicio y fin
	   	if ($scope.showHourRange && $scope.validFormWhenHoursActived) {
	   		params["start_hour"] = formatDateToString($scope.horaInicio);
	   		params["end_hour"] = formatDateToString($scope.horaFin);
	   	}
	   	return params;
	};

	var sendBroadcast = function() {
		var data = $scope.doGetParams();
   		NotificationService.sendScopeChanged(data);
	};

	var sendBroadcastUnique = function() {
		var data = $scope.doGetParams();
   		NotificationService.sendUniqueChanged(data);	
	}

   	$scope.changedCheckBoxUniqueVisitors = function(validForm, validDates) {
   		var checkHoursOk = ($scope.showHourRange && validForm && (!$scope.dates.consistent) && (!$scope.startNotLesserEnd))
   		 	|| (!$scope.showHourRange && validDates && (!$scope.dates.consistent));
   		// Antes de realizar la peticion, comprobamos si está activo el formulario
   		// de las horas. Si es así y el formulario es válido, OK, pero si no está activo tiene que ser
   		// válido porque no se va a tener en cuenta si las horas son válidas o no, se hará una petición con la hora estándar
   		// de un día (de 00:00:00 a 23:59:59)
		if(!$scope.dates.consistent && validForm && checkHoursOk) {
			sendBroadcastUnique();
   		}
   	};

	$scope.changedHour = function(validForm) {
	   	$scope.startNotLesserEnd = ($scope.horaInicio > $scope.horaFin); 
	   	// Tenemos que comprobar si todo el formulario de filtros es válido antes de hacer ninguna petición
	   	$scope.validFormWhenHoursActived = validForm;
	   	if ($scope.validFormWhenHoursActived && !$scope.startNotLesserEnd && !$scope.dates.consistent) {
	   		sendBroadcast();
		}
	};

	$scope.changedDate = function(validForm) {
		$scope.dates.consistent = ($scope.fechaFin < $scope.fechaInicio); 
		if (!$scope.dates.consistent && (validForm)) {
	   		sendBroadcast();
	   	}
	};
	formatDateToString = function(date) {
		// Concatenamos un "0" al principio junto con slice para, en el caso de tener una hora, minuto o segundo de una sola cifra, convertirlo
	   	// en el formato HH:MM:SS (2 cifras cada uno)
		return ("0" + (date.getHours())).slice(-2) + ":" + ("0" + (date.getMinutes())).slice(-2) + ":" + ("0" + (date.getSeconds())).slice(-2)
	};

	$scope.changedCheckBoxHourRange = function(fechaIniValid, fechaFinValid, horaIniValid, horaFinValid) {
		var validDates = fechaIniValid && fechaFinValid;
		var validHours = horaIniValid && horaFinValid;
		// ok será true si no está activo el form de horas y las fechas son válidas, o si el form está activo y 
		// tanto las fechas como las horas son válidas
		var ok = (!$scope.showHourRange) ? validDates : (validDates && validHours && !$scope.startNotLesserEnd);
		// Si la hora inicio y fin al checkear y descheckear son iguales que el inicio y final de un dia, respectivamente, no
	   	// es necesario realizar de nuevo otra petición. Comprobamos además que el formulario sea válido
	   	if (!(($scope.horaInicio == inicioDia) && ($scope.horaFin == finDia)) && ok) {
	   		sendBroadcast();
	   	}
	}

});
