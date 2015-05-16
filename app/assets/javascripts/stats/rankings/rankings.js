var app = angular.module("icecastStats");

app.controller("CountryRanking" , function ($scope, GenericRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('country_ranking', params, scope, GenericRanking);
		$scope.response.$promise.then(function (result) {
    		$scope.backButton = (($scope.startIndex - $scope.count) >= 0);
		 	$scope.hasMore = RankingUtilities.containsHasMore(result);
		 	$scope.data = result;
		});
	};
	doGetData($scope.$parent.doGetParams());

	$scope.anterior = function() {
		$scope.startIndex -= $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	$scope.siguiente = function() {
		$scope.startIndex += $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	NotificationService.onChangeScope($scope, function(message) {
		$scope.data = [];
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("RegionRanking" , function ($scope, GenericRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('region_ranking', params, scope, GenericRanking);
		$scope.response.$promise.then(function (result) {
    		$scope.backButton = (($scope.startIndex - $scope.count) >= 0);
		 	$scope.hasMore = RankingUtilities.containsHasMore(result);
		 	$scope.data = result;
		});
	};
	doGetData($scope.$parent.doGetParams());

	$scope.anterior = function() {
		$scope.startIndex -= $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	$scope.siguiente = function() {
		$scope.startIndex += $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	NotificationService.onChangeScope($scope, function(message) {
		$scope.data = [];
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("CityRanking" , function ($scope, GenericRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('city_ranking', params, scope, GenericRanking);
		$scope.response.$promise.then(function (result) {
    		$scope.backButton = (($scope.startIndex - $scope.count) >= 0);
		 	$scope.hasMore = RankingUtilities.containsHasMore(result);
		 	$scope.data = result;
		});
	};
	doGetData($scope.$parent.doGetParams());

	$scope.anterior = function() {
		$scope.startIndex -= $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	$scope.siguiente = function() {
		$scope.startIndex += $scope.count;
		doGetData($scope.$parent.doGetParams());
	};

	NotificationService.onChangeScope($scope, function(message) {
		$scope.data = [];
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});