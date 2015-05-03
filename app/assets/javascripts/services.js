var iceServices = angular.module("iceServices", ['ngResource']);

iceServices.factory("Years", ['$resource', function($resource) {
  return $resource('connections/years.json', {}, {})	;
}]);

iceServices.factory("YearsConnections", ['$resource', function($resource) {
  return $resource('connections.json', {}, 	{})	;
}]);

iceServices.factory("Ranges", ['$resource', function($resource) {
  return $resource('connections/ranges/:start_date/:end_date/:unique_visitors/:max/:min/:start_hour/:end_hour:json', 
  			{start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', 
	     		max: "@max", min : "@min", start_hour: "00:00:00", end_hour : "23:59:59"}, 
	     	{isArray : false});
}]);

iceServices.factory("ConnectionsBetweenDates", ['$resource', function($resource) {
	  return $resource('connections/connections_between_dates/:start_date/:end_date/:group_by/:unique_visitors/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', group_by : '@group_by', unique_visitors : '@unique_visitors', 
	     	start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false});
}]);

iceServices.factory("Sources", ['$resource', function($resource) {
	  return $resource('sources/:source:json', {source: '@source'}, {});
}]);

iceServices.factory("IceCastServer", ['$resource', function($resource) {
		return $resource('poll/:url', {url: '@url'}, {isArray : false});
}]);