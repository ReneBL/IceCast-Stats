var app = angular.module('icecastStats');

app.directive("chart", function() {
	  return function($scope, elm, attrs) {
	  	   var chart = null;
	  	   switch(attrs.chartType) {
	  	   	  case 'Bar' : chart = new google.visualization.BarChart(elm[0]);
	  	   	               break;
	  	   	  case 'Pie' : chart = new google.visualization.PieChart(elm[0]);
	  	   	               break;
	  	   	  case 'Column' : chart = new google.visualization.ColumnChart(elm[0]);
	  	   	                  break;
	  	   	  case 'Calendar' : chart = new google.visualization.Calendar(elm[0]);
	  	   	                    break;
	  	   	  case 'Geo' : chart = new google.visualization.GeoChart(elm[0]);
	  	   	  			   break;
	  	   	  case 'Line' : chart = new google.visualization.LineChart(elm[0]);
	  	   	  				break;
	  	   	  case 'Combo' : chart = new google.visualization.AreaChart(elm[0]);
	  	   	  				 break;
	  	   	  case 'Stepped' : chart = new google.visualization.SteppedAreaChart(elm[0]);
	  	   	  				   break;
	  	   	  default: console.log('Gráfica no disponible');
	  	   }
	  	   $scope.$watch('data', function(n, o) {
	  	   		chart != null ? chart.draw($scope.data, $scope.options) : console.log("Error interno");
	  	   });
	  };
});