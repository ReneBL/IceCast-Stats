var app = angular.module('icecastStats', ['snap', 'ngRoute', 'templates', 'iceServices',
    'connFactories', 'configState', 'dataServerParser', 'notificationService']);

app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'home/_home.html'
        //controller: 'PruebaController'
      }).
      when('/stats', {
      	  templateUrl: 'stats/_stats.html'
      	  //controller: 'StatsController'
      }).
      when('/config', {
          templateUrl : 'config/_config.html'
          //controller: 'ConfigurationController'
      }).
      otherwise({
        redirectTo: '/'
      });
  }]);

google.setOnLoadCallback(function () {
	  angular.bootstrap(document.body, ['icecastStats']);
});
