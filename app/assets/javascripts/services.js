var iceServices = angular.module("iceServices", ['ngResource']);

iceServices.factory("Years", ['$resource', function($resource) {
  return $resource('connections/years.json', {}, {})	;
}]);

iceServices.factory("YearsConnections", ['$resource', function($resource) {
  return $resource('connections.json', {}, 	{})	;
}]);

iceServices.factory("Ranges", ['$resource', function($resource) {
  return $resource('connections/ranges.json', {}, {})	;
}]);

iceServices.factory("ConnectionsBetweenDates", ['$resource', function($resource) {
	  return $resource('connections/connections_between_dates/:start_date/:end_date/:group_by/:unique_visitors:json', 
	     {start_date : '@start_date', end_date : '@end_date', group_by : '@group_by', unique_visitors : '@unique_visitors'}, {isArray : false});
}]);

iceServices.factory("Sources", ['$resource', function($resource) {
	  return $resource('sources/:source:json', {source: '@source'}, {});
}]);