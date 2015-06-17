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

var app = angular.module("icecastStats");

app.controller("CountryRanking" , function ($scope, GenericPaginatedRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('country_ranking', params, scope, GenericPaginatedRanking);
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
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("RegionRanking" , function ($scope, GenericPaginatedRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('region_ranking', params, scope, GenericPaginatedRanking);
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
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("CityRanking" , function ($scope, GenericPaginatedRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('city_ranking', params, scope, GenericPaginatedRanking);
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
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("UserAgentRanking" , function ($scope, GenericPaginatedRanking, START_INDEX, COUNT, RankingUtilities, NotificationService) {

	$scope.hasMore = false;
	$scope.startIndex = START_INDEX;
	$scope.count = COUNT;
	$scope.backButton = (($scope.startIndex - $scope.count) >= 0);

	var doGetData = function (params) {
		var scope = {startIndex: $scope.startIndex, count: $scope.count};
		$scope.response = RankingUtilities.makeRequest('user_agent_ranking', params, scope, GenericPaginatedRanking);
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
		$scope.startIndex = START_INDEX;
		doGetData($scope.$parent.doGetParams());
	});
});

app.controller("LinksRanking" , function ($scope, LinksRanking, RankingUtilities, NotificationService) {

	var doGetData = function (params) {
		var cloneParams = angular.copy(params);
		delete cloneParams.unique_visitors;
		LinksRanking.query(cloneParams, function (result) {
    		$scope.count = result.length;
		 	$scope.data = result;
		});
	};
	doGetData($scope.$parent.doGetParams());

	NotificationService.onChangeScope($scope, function(message) {
		doGetData($scope.$parent.doGetParams());
	});
});