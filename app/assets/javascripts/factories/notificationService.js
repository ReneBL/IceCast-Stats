var app = angular.module('notificationService', []);

app.factory("NotificationService", function($rootScope) {

	var REFRESH_STATS = "refreshStats";

	// Evento que indica que queremos filtrar por visitantes únicos
	var UNIQUE_VISITORS_STATS = "uniqueStats";

	var send = function(params) {
		$rootScope.$broadcast(REFRESH_STATS, {params: params});
	};

	var react = function($scope, handler) {
		$scope.$on(REFRESH_STATS, function(event, message) {
			handler(message);
		});
	};

	var sendUnique = function(params) {
		$rootScope.$broadcast(UNIQUE_VISITORS_STATS, {params: params});
	};

	var reactUnique = function($scope, handler) {
		$scope.$on(UNIQUE_VISITORS_STATS, function(event, message) {
			handler(message);
		});
	};

	return {
		sendScopeChanged: send,
		onChangeScope: react,
		sendUniqueChanged: sendUnique,
		onUniqueChanged : reactUnique
	};
});