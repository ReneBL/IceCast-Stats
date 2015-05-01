var app = angular.module('icecastStats');
app.controller('ConnectionsController', function() {

});
app.controller('YearsConnectionsController', function($scope, YearsConnections) {  

});

app.controller('YearsController', function($scope, Years) {
	//Inyectamos los servicios RESTFul implementados con $resource
	  $scope.data = Years.query(function (data) {
    $scope.years = data;
    $scope.year = data[0];
	  });
});

app.controller('RangesController', function($scope, Ranges) {
	   $scope.datos = Ranges.query(function(datos) {
	     var array = [['Range', 'Connections per range']];
	     for(var i=0; i < datos.length; i++) {
	   	     array.push([datos[i]._id, datos[i].count]);
	     }
	     $scope.data = google.visualization.arrayToDataTable(array);
     $scope.options = {
       title: 'Mean duration of connections',
       is3D: true,
     };
     $scope.rangesDataLoaded = true;
   });
});

app.controller('DatesController', function($scope, $filter, ConnectionsBetweenDates, ConnBetDatesDataProvider,
	  ConnBetDatesOptionsProvider) {
	  	
	   var fechaActual = new Date();
	   $scope.fechaInicio = fechaActual;
	   $scope.fechaFin = fechaActual;
	   var inicioDia = new Date(1970, 0, 1, 00, 00, 00, 0);
	   var finDia = new Date(1970, 0, 1, 23, 59, 59, 0);
	   $scope.horaInicio = inicioDia;
	   $scope.horaFin = finDia;
	   $scope.showHourRange = false;
	   $scope.validHoursForm = true;
	   $scope.groupBy = 'year';
	   $scope.unique = false;
	   $scope.invalid = false;

   	$scope.$watch("unique", function(newValue, oldValue) {
   			// Antes de realizar la peticion, comprobamos si las fechas son validas
   		   if(!$scope.invalid) {
   		   	  cleanContext();
   		   	  $scope.doGetData();
   		   }
   	});
	   	$scope.doGetData = function() {
	   		var params = {start_date : $filter('date')($scope.fechaInicio, 'dd/MM/yyyy'), 
	   	     end_date : $filter('date')($scope.fechaFin, 'dd/MM/yyyy'), group_by : $scope.groupBy,
	   	     unique_visitors : $scope.unique.toString()};

	   	  // Solo si el checkbox está activado y las horas son validas las añadimos como parametros
	   	  // validHoursForm se seteará a true cuando haya un cambio en la hora inicio o fin y el formulario que las engloba
	   	  // es correcto. Es decir, si hora inicio y hora fin son correctas
	   	  if ($scope.showHourRange && $scope.validHoursForm) {
	   	  	params["start_hour"] = formatDateToString($scope.horaInicio);
	   	  	params["end_hour"] = formatDateToString($scope.horaFin);
	   	  }
	   	   ConnectionsBetweenDates.query(params, function(datos) {
	   	     	 $scope.dataEmpty = datos.length == 0;
	   	     	 if (!$scope.dataEmpty) {
	   	     	 	  $scope.data = ConnBetDatesDataProvider.provide($scope.groupBy, datos);
	   	     	 	  $scope.options = ConnBetDatesOptionsProvider.provide($scope.groupBy);
	   	     	 	  $scope.loaded = true;
	         } else {
	         	  	$scope.loaded = false;
	         }
	      });
	   };
	   
	   $scope.data = $scope.doGetData();
	   $scope.changedDate = function() {
	   	   	if ($scope.fechaFin < $scope.fechaInicio) {
	   	   	   $scope.invalid = true;
	   	   } else {
	   	   	   cleanContext();
	   	   	   $scope.invalid = false;
	   	   	   $scope.doGetData();
	   	   }
	   };

	   $scope.changedHour = function(validForm) {
	   		$scope.startNotLesserEnd = ($scope.horaInicio > $scope.horaFin); 
	   		$scope.validHoursForm = validForm;
	   		if ($scope.validHoursForm && !$scope.startNotLesserEnd) {
	   			cleanContext();
	   			$scope.doGetData();
	   		}
	   };
	   
	   $scope.group = function(value) {
	   	   if($scope.groupBy != value) { 	 
	   	   	  cleanContext(); 
	   	      $scope.groupBy = value;
	   	      $scope.doGetData();
	   	   }
	   };
	   
	   cleanContext = function() {
	   	   $scope.data = null;
	   	   $scope.options = null;
	   	   $scope.loaded = false;
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
	   			cleanContext();
	   			$scope.doGetData();
	   		}
	   }
});
