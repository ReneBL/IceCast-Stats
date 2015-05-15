var iceServices = angular.module("iceServices", ['ngResource']);

iceServices.factory("CountriesRanking", ['$resource', function($resource) {
  return $resource('ranking/country_ranking/:start_date/:end_date/:start_index/:count/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_index : '0', count : '10', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false})	;
}]);

iceServices.factory("Ranges", ['$resource', function($resource) {
  return $resource('connections/ranges/:start_date/:end_date/:unique_visitors/:max/:min/:start_hour/:end_hour:json', 
  			{start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', 
	     		max: "@max", min : "@min", start_hour: "00:00:00", end_hour : "23:59:59"}, 
	     	{isArray : false});
}]);

iceServices.factory("TotalTime", ['$resource', function($resource) {
	  return $resource('connections/total_seconds/:start_date/:end_date/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false});
}]);

iceServices.factory("AvgTime", ['$resource', function($resource) {
	  return $resource('connections/avg_seconds/:start_date/:end_date/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false});
}]);

iceServices.factory("ConnectionsBetweenDates", ['$resource', function($resource) {
	  return $resource('connections/connections_between_dates/:start_date/:end_date/:group_by/:unique_visitors/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', group_by : '@group_by', unique_visitors : '@unique_visitors', 
	     	start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false});
}]);

iceServices.factory("GroupedTotalSeconds", ['$resource', function($resource) {
	  return $resource('connections/total_seconds_grouped/:start_date/:end_date/:group_by/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', group_by : '@group_by', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false});
}]);

iceServices.factory("CountriesConnections", ['$resource', function($resource) {
	  return $resource('locations/countries/:start_date/:end_date/:unique_visitors/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {});
}]);

iceServices.factory("CountriesTotalTime", ['$resource', function($resource) {
	  return $resource('locations/countries_time/:start_date/:end_date/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {});
}]);

iceServices.factory("RegionsConnections", ['$resource', function($resource) {
	  return $resource('locations/regions/:start_date/:end_date/:country/:unique_visitors/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', country : '@country',
	     	start_hour: "00:00:00", end_hour : "23:59:59"},
	     {});
}]);

iceServices.factory("RegionsTotalTime", ['$resource', function($resource) {
	  return $resource('locations/regions_time/:start_date/:end_date/:country/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', country : "@country", start_hour: "00:00:00", end_hour : "23:59:59"},
	     {});
}]);

iceServices.factory("Sources", ['$resource', function($resource) {
	  return $resource('sources/:source:json', {source: '@source'}, {});
}]);

iceServices.factory("Countries", ['$resource', function($resource) {
	  return $resource('locations/get_countries:json', {}, {isArray : false});
}]);

iceServices.factory("Programs", ['$resource', function($resource) {
  return $resource('connections/programs/:start_date/:end_date/:unique_visitors/:start_hour/:end_hour:json', 
  			{start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', 
	     		start_hour: "00:00:00", end_hour : "23:59:59"}, 
	     	{isArray : false});
}]);

iceServices.factory("IceCastServer", ['$resource', function($resource) {
		return $resource('poll/:url', {url: '@url'}, {isArray : false});
}]);