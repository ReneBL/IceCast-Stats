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
	  	
	   var fechaSinFormatear = new Date();
	   var fechaActual = new Date();
	   $scope.fechaInicio = fechaActual;
	   $scope.fechaFin = fechaActual;
	   $scope.groupBy = 'year';
	   $scope.unique = false;
	   $scope.invalid = false;

   $scope.$watch("unique", function(newValue, oldValue) {
   	   if(!$scope.invalid) {
   	   	  cleanContext();
   	   	  $scope.doGetData();
   	   }
   });

	   	$scope.doGetData = function() {
	   	   ConnectionsBetweenDates.query({start_date : $filter('date')($scope.fechaInicio, 'dd/MM/yyyy'), 
	   	     end_date : $filter('date')($scope.fechaFin, 'dd/MM/yyyy'), group_by : $scope.groupBy,
	   	     unique_visitors : $scope.unique.toString()}, function(datos) {
	   	     	
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
	   
	   $scope.data = $scope.doGetData()	;
	   $scope.changedDate = function() {
	   	   	if ($scope.fechaFin < $scope.fechaInicio) {
	   	   	   $scope.invalid = true;
	   	   } else {
	   	   	   cleanContext();
	   	   	   $scope.invalid = false;
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
});
