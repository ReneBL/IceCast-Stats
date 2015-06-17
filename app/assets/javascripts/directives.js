/**********************************************************************************
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
**********************************************************************************/

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
	  	   	  default: console.log('Gráfica no disponible');
	  	   }
	  	   $scope.$watch('data', function(n, o) {
	  	   		chart != null ? chart.draw($scope.data, $scope.options) : console.log("Error interno");
	  	   });
	  };
});