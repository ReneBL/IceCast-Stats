var app = angular.module('icecastStats');
app.controller('ConnectionsController', function() {

});
app.controller('YearsConnectionsController', function($scope, YearsConnections) {  
	  $scope.datos = YearsConnections.query(function (datos) {
	  	  var array = [["Year", "Listeners"]];
	    for(var i=0; i < datos.length; i++) {
	   	   array.push([datos[i]._id.year.toString(), datos[i].count]);
	    }
	    $scope.data = new google.visualization.arrayToDataTable(array);
	    $scope.options = {
	   	   title : 'Number of connections per year',
	   	   animation : {
	   	   	   duration : 5000,
	   	   	   startup : 'true',
	   	   	   easing : 'linear'
	   	   },
	   	   legend: { position: 'none' },
	   	   chart: { 
	   	   	   title: 'Connections',
         subtitle: 'amount per year' 
      },
      bars : 'horizontal',
      axes: {
            x: {
              0: { side: 'top', label: 'Listeners'} // Top x-axis.
            }
          },
          bar: { groupWidth: "90%" }
	    };
	   	 $scope.yearsChartLoaded = true;
	  });
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