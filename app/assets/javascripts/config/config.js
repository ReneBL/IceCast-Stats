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

var app = angular.module('icecastStats');

app.controller('ConfigurationController', function ($scope, Sources, StateFactory, CONFIGURATION) {
	$scope.refreshSeconds = StateFactory.getRefreshSeconds() / 1000;
	$scope.refreshMinutes = StateFactory.getRefreshMinutes() / 60000;
	$scope.server = StateFactory.getServer();

	Sources.query(function (data) {
		$scope.sources = data;
		$scope.sources.unshift(CONFIGURATION.DEFAULT_SOURCE);
		// Recuperamos el estado de la factoria e inicializamos el model
		$scope.source = StateFactory.getSelectedSource();
	});

	$scope.$watch("source", function(newValue, oldValue) {
			if(newValue != oldValue){
					Sources.save({source: newValue});
					// Guardamos el estado en la factoria
					StateFactory.setSelectedSource(newValue);
				}
		});

	$scope.setRefreshSeconds = function (validForm) {
		if (validForm) {
			var seconds = $scope.refreshSeconds * 1000;
			StateFactory.setRefreshSeconds(seconds);
		}
	};

	$scope.setRefreshMinutes = function (validForm) {
		if (validForm) {
			var minutes = $scope.refreshMinutes * 60000;
			StateFactory.setRefreshMinutes(minutes);
		}
	};

	$scope.setServer = function (validForm) {
		if (validForm) {
			var server = $scope.server;
			StateFactory.setServer(server);
		}
	};
});