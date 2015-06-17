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

var app = angular.module("rankingFactories", []);

app.factory("RankingUtilities", function() {
	// Itera sobre el array de json devuelto por el backend y comprueba si existe el elemento "hasMore"
	// Si existe, devuelve su resultado, si no, devuelve false
	var containsHasMore = function (data) {
		var result = false;
		for(var i=0; i<data.length; i++) {
			if (data[i].hasOwnProperty("hasMore")) {
				result = data[i].hasMore;
				data.splice(i, 1);
				break;	
			} else {
				continue;
			}
		}
		return result;
	}

	var request = function (idUrl, params, scope, service) {
		var cloneParams = angular.copy(params);
		cloneParams["start_index"] = scope.startIndex;
		cloneParams["count"] = scope.count;
		cloneParams["idUrl"] = idUrl;
		delete cloneParams.unique_visitors;
		return service.query(cloneParams);
	};

	return {
		containsHasMore: containsHasMore,
		makeRequest: request
	}
});