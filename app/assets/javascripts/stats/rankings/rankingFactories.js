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

	return {
		containsHasMore: containsHasMore
	}
});