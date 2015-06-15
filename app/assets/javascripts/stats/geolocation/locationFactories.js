var icecast = angular.module("locationFactories", ['timeFactory']);

icecast.factory("CountriesConnectionsDataProvider", function (SecondsConverter, CONNECTIONS) {
     	return {
         provide : function(datos, dataType) {
            var numConnections = (dataType == CONNECTIONS.TOTAL_LISTENERS);
            var countColumnName = numConnections ? CONNECTIONS.TOTAL_LISTENERS : CONNECTIONS.TOTAL_SECONDS;
         	dataCC = new google.visualization.DataTable();
            dataCC.addColumn({ type: 'string', label: 'Pais' });
            dataCC.addColumn({ type: 'number', label: countColumnName });
            if (!numConnections) {
                dataCC.addColumn({type: 'string', role: 'tooltip'});
            }
       		for(var i=0; i < datos.length; i++) {
          		if (numConnections) {
                    dataCC.addRow([datos[i]._id.country, datos[i].count])
                } else {
                    str = SecondsConverter.toStringSeconds(datos[i].count);
                    dataCC.addRow([datos[i]._id.country, datos[i].count, countColumnName + ': ' + str]);
                }
       		}
        	return dataCC;
         }
     	};
});

icecast.factory("CountriesConnectionsOptionsProvider", function() {
     return {
         provide : function() {
            var options = {
              displayMode : 'auto',
              width : '100%'
            };
            return options;
        }
     };
});

icecast.factory("RegionsCitiesDataProvider", function (SecondsConverter, CONNECTIONS) {
        return {
         provide : function(datos, dataType, citiesChecked) {
            var numConnections = (dataType == CONNECTIONS.TOTAL_LISTENERS);
            var countColumnName = numConnections ? CONNECTIONS.TOTAL_LISTENERS : CONNECTIONS.TOTAL_SECONDS;
            var titleName = citiesChecked ? 'Ciudad' : 'Región';
            dataRC = new google.visualization.DataTable();
            dataRC.addColumn({ type: 'string', label: titleName });
            dataRC.addColumn({ type: 'number', label: countColumnName });
            if (!numConnections) {
                dataRC.addColumn({type: 'string', role: 'tooltip'});
            }
            for(var i=0; i < datos.length; i++) {
                if (numConnections) {
                    citiesChecked ? dataRC.addRow([datos[i]._id.city, datos[i].count]) :
                        dataRC.addRow([datos[i]._id.region, datos[i].count]);
                } else {
                    hms = SecondsConverter.toStringSeconds(datos[i].count);
                    citiesChecked ? dataRC.addRow([datos[i]._id.city, datos[i].count, countColumnName + ': ' + hms]) :
                        dataRC.addRow([datos[i]._id.region, datos[i].count, countColumnName + ': ' + hms]);
                }
            }
            return dataRC;
         }
        };
});

icecast.factory("RegionsCitiesOptionsProvider", function() {
     return {
         provide : function(region) {
            var options = {
                region: region,
                displayMode : 'markers',
                backgroundColor: '#81d4fa'
            };
            return options;
        }
     };
});
