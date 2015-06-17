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

var app = angular.module('icecastStats', ['ngAnimate', 'snap', 'ngRoute', 'templates', 'iceServices',
    'connFactories', 'configState', 'dataServerParser', 'notificationService', 'locationFactories', 
    'timeFactory', 'rankingFactories', 'iso-3166-country-codes', 'filters', 'homeFactories']);

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
    }).constant('CONFIGURATION', {
      'DEFAULT_SOURCE': 'Todos',
      'DEFAULT_POLL_URL': 'http://streaming.cuacfm.org/status-json.xsl',
      'DEFAULT_REFRESH_SECONDS': 5000, // A milisegundos (5 segundos)
      'DEFAULT_REFRESH_MINUTES': 60000 // A milisegundos (1 minuto)
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
