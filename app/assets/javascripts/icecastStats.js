var app = angular.module('icecastStats', ['snap', 'ngRoute', 'templates', 'iceServices']);

app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'home/_prueba.html',
        controller: 'PruebaController'
      }).
      when('/stats', {
      	  templateUrl: 'stats/_stats.html',
      	  controller: 'StatsController'
      }).
      otherwise({
        redirectTo: '/'
      });
  }]);

google.setOnLoadCallback(function () {
	  angular.bootstrap(document.body, ['icecastStats']);
});
