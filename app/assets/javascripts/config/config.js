var app = angular.module('icecastStats');

app.controller('ConfigurationController', function($scope, Sources, StateFactory) {
	$scope.changedSource = false;
	$scope.refreshSeconds = StateFactory.getRefreshSeconds() / 1000;
	$scope.server = StateFactory.getServer();
	Sources.query(function (data) {
		$scope.sources = data;
		$scope.sources.unshift('Todos');
		// Recuperamos el estado de la factoria e inicializamos el model
		$scope.source = StateFactory.getSelectedSource();
	});
	$scope.$watch("source", function(newValue, oldValue) {
   		if(newValue != oldValue){
   	   		Sources.save({source: newValue});
   	   		// Guardamos el estado en la factoria
   	   		StateFactory.setSelectedSource(newValue);
   	   		$scope.changedSource = true;
   	    }
    });
  $scope.$watch("refreshSeconds", function(newValue, oldValue) {
   	if(newValue != oldValue){
   	   		StateFactory.setRefreshSeconds(newValue * 1000);
   	  }
  });
  $scope.setServer = function () {
    var server = $scope.server;
    StateFactory.setServer(server);
  };
});