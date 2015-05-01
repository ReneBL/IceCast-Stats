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

app.controller('ConnectionsGroupedChartController', function($scope, ConnectionsBetweenDates, ConnBetDatesDataProvider,
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
	   	     	$scope.loaded = true;
	    	} else {
	        	$scope.loaded = false;
	        }
		});
	};

	// Debemos hacer esta llamada. Solo se realiza cuando se inicializa el controlador. Esto es necesario ya que seria muy arriesgado
	// inicializar los datos mediante un broadcast del controlador padre, ya que lo recibirían TODOS los controladores que estén suscritos
	// al broadcast, y por lo tanto se harían peticiones innecesarias, reduciendo el rendimiento considerablemente.
	$scope.data = $scope.doGetData($scope.$parent.doGetParams());
   
	$scope.group = function(value) {
		if($scope.groupBy != value) { 	 
			cleanContext(); 
	   		$scope.groupBy = value;
	   	    $scope.doGetData($scope.$parent.doGetParams());
	   	}
	};
	   
	cleanContext = function() {
		$scope.data = null;
	   	$scope.options = null;
	   	$scope.loaded = false;
	};

	NotificationService.onChangeScope($scope, function(message) {
		cleanContext();
		$scope.doGetData(message.params);
	});
});
