var module = angular.module("configState", []);

module.factory("StateFactory", function() {
	var getSource = function() {
		return this.source;
	}

	var setSource = function(source) {
		this.source = source;
	};

	return {
		source: 'Todos',
		getSelectedSource: getSource,
		setSelectedSource: setSource
	};
});