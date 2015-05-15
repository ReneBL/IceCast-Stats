var app = angular.module('icecastStats', ['snap', 'ngRoute', 'templates', 'iceServices',
    'connFactories', 'configState', 'dataServerParser', 'notificationService', 'ui-rangeSlider', 
    'locationFactories', 'timeFactory', 'rankingFactories', 'iso-3166-country-codes']);

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

app.constant('START_INDEX', 0).
    constant('COUNT', 5);

app.config(function(snapRemoteProvider) {
  snapRemoteProvider.globalOptions = {
    touchToDrag: 'false',
    disable: 'right'
  };
});

google.setOnLoadCallback(function () {
	  angular.bootstrap(document.body, ['icecastStats']);
});
