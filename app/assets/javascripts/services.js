var iceServices = angular.module("iceServices", ['ngResource']);

iceServices.factory("Years", ['$resource', function($resource) {
  return $resource('connections/years.json', {}, 	{})	;
}]);

iceServices.factory("YearsConnections", ['$resource', function($resource) {
  return $resource('connections.json', {}, 	{})	;
}]);

iceServices.factory("Ranges", ['$resource', function($resource) {
  return $resource('connections/ranges.json', {}, 	{})	;
}]);