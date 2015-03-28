'use strict';

var app = angular.module('icecastStats');

app.directive("chart", function() {
	  return function($scope, elm, attrs) {
	  	   var chart = null;
	  	   switch(attrs.chartType) {
	  	   	  case 'Bar' : chart = new google.charts.Bar(elm[0]);
	  	   	               break;
	  	   	  case 'Pie' : chart = new google.visualization.PieChart(elm[0]);
	  	   	               break;
	  	   	  default: console.log('Gráfica no disponible');
	  	   }
	  	   chart != null? chart.draw($scope.data, $scope.options) : console.log("Error interno");
	  };
});
