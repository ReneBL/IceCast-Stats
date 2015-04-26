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
