var app = angular.module('icecastStats', ['snap', 'ngRoute', 'templates', 'iceServices',
    'connFactories', 'configState', 'dataServerParser', 'notificationService', 'locationFactories', 
    'timeFactory', 'rankingFactories', 'iso-3166-country-codes', 'filters']);

app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'home/_home.html'
      }).
      when('/stats', {
      	  templateUrl: 'stats/_stats.html'
      }).
      when('/config', {
          templateUrl : 'config/_config.html'
      }).
      otherwise({
        redirectTo: '/'
      });
  }]);

app.constant('START_INDEX', 0).
    constant('COUNT', 5).
    constant('CONNECTIONS', {
      'TOTAL_SECONDS': "Segundos totales",
      'TOTAL_LISTENERS': "Oyentes totales"
    }).constant('GROUP_BY', {
      'YEAR': "year",
      'MONTH': "month",
      "DAY": "day"
    });

app.config(function(snapRemoteProvider) {
  snapRemoteProvider.globalOptions = {
    touchToDrag: 'false',
    disable: 'right'
  };
});

google.setOnLoadCallback(function () {
	  angular.bootstrap(document.body, ['icecastStats']);
});
