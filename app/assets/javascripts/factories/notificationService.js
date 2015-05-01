var app = angular.module('notificationService', []);

app.factory("NotificationService", function($rootScope) {

	var REFRESH_STATS = "refreshStats";

	var send = function(params) {
		$rootScope.$broadcast(REFRESH_STATS, {params: params});
	};

	var react = function($scope, handler) {
		$scope.$on(REFRESH_STATS, function(event, message) {
			handler(message);
		});
	};

	return {
		sendScopeChanged: send,
		onChangeScope: react
	};
});