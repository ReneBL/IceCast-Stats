var app = angular.module("icecastStats");

app.controller("CountryRanking" , function ($scope, CountriesRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var cloneParams = angular.copy(params);
		cloneParams["start_index"] = $scope.startIndex;
		cloneParams["count"] = $scope.count;
		delete cloneParams.unique_visitors;
		CountriesRanking.query(cloneParams, function (datos) {
			$scope.backButton = (($scope.startIndex - $scope.count) >= 0);
			$scope.hasMore = RankingUtilities.containsHasMore(datos);
			$scope.data = datos;
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
		doGetData($scope.$parent.doGetParams());
	});
});