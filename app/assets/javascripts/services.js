var iceServices = angular.module("iceServices", ['ngResource']);

// ----------- RANKING SERVICES ------------- //
iceServices.constant('START_INDEX', 0).
    constant('COUNT', 5);

iceServices.factory("GenericPaginatedRanking", ['$resource', function($resource, START_INDEX, COUNT) {
  return $resource('ranking/:idUrl/:start_date/:end_date/:start_index/:count/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_index : START_INDEX, count : COUNT, 
	     	start_hour: "00:00:00", end_hour : "23:59:59", idUrl : "@idUrl"},
	     {isArray : false})	;
}]);

iceServices.factory("LinksRanking", ['$resource', function($resource) {
  return $resource('ranking/top_links_ranking/:start_date/:end_date/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', start_hour: "00:00:00", end_hour : "23:59:59"},
	     {isArray : false})	;
}]);

// ----------- END: RANKING SERVICES ------- //

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

iceServices.factory("Programs", ['$resource', function($resource) {
  return $resource('connections/programs/:start_date/:end_date/:unique_visitors/:start_hour/:end_hour:json', 
  			{start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', 
	     		start_hour: "00:00:00", end_hour : "23:59:59"}, 
	     	{isArray : false});
}]);

// ----------- GEOLOCATION SERVICES ------------- //
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
	     	start_hour: "00:00:00", end_hour : "23:59:59"}, {});
}]);

iceServices.factory("RegionsTotalTime", ['$resource', function($resource) {
	  return $resource('locations/regions_time/:start_date/:end_date/:country/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', country : "@country", start_hour: "00:00:00", end_hour : "23:59:59"},
	     {});
}]);

iceServices.factory("CitiesTotalTime", ['$resource', function($resource) {
	  return $resource('locations/cities_time/:start_date/:end_date/:country/:region/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', country : "@country", region : "@region", 
	     	start_hour: "00:00:00", end_hour : "23:59:59"}, {});
}]);

iceServices.factory("CitiesConnections", ['$resource', function($resource) {
	  return $resource('locations/cities/:start_date/:end_date/:country/:region/:unique_visitors/:start_hour/:end_hour:json', 
	     {start_date : '@start_date', end_date : '@end_date', unique_visitors : '@unique_visitors', 
	     	country : '@country', region : "@region", start_hour: "00:00:00", end_hour : "23:59:59"}, {});
}]);

iceServices.factory("Countries", ['$resource', function($resource) {
	  return $resource('locations/get_countries:json', {}, {isArray : false});
}]);

iceServices.factory("Regions", ['$resource', function($resource) {
	  return $resource('locations/get_regions/:country:json', {country : '@country'}, {isArray : false});
}]);

// ----------- END: GEOLOCATION SERVICES -------- //

iceServices.factory("Sources", ['$resource', function($resource) {
	  return $resource('sources/:source:json', {source: '@source'}, {});
}]);

iceServices.factory("IceCastServer", ['$resource', function($resource) {
		return $resource('poll/:url', {url: '@url'}, {isArray : false});
}]);

iceServices.factory("LastConnections", ['$resource', function($resource) {
		return $resource('real_time/last_connections:json', {}, {isArray : false});
}]);