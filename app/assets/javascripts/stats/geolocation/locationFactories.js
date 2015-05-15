var icecast = angular.module("locationFactories", []);

icecast.factory("CountriesConnectionsDataProvider", function() {
     	return {
         provide : function(datos, dataType) {
            countColumnName = (dataType == 'numConnections') ? 'Conexiones' : 'Segundos totales de escucha'; 
         	dataCC = new google.visualization.DataTable();
            dataCC.addColumn({ type: 'string', label: 'Pais' });
            dataCC.addColumn({ type: 'number', label: countColumnName });
       		for(var i=0; i < datos.length; i++) {
          		dataCC.addRow([datos[i]._id.country, datos[i].count]);
       		}
        	return dataCC;
         }
     	};
});

icecast.factory("CountriesConnectionsOptionsProvider", function() {
     return {
         provide : function() {
            return {displayMode : 'auto'};
        }
     };
});

icecast.factory("RegionsDataProvider", function() {
        return {
         provide : function(datos, dataType) {
            countColumnName = (dataType == 'numConnections') ? 'Conexiones' : 'Segundos totales de escucha'; 
            dataCC = new google.visualization.DataTable();
            dataCC.addColumn({ type: 'string', label: 'Región' });
            dataCC.addColumn({ type: 'number', label: countColumnName });
            for(var i=0; i < datos.length; i++) {
                dataCC.addRow([datos[i]._id.region, datos[i].count]);
            }
            return dataCC;
         }
        };
});

icecast.factory("RegionsOptionsProvider", function() {
     return {
         provide : function(region) {
            var options = {
                region: region,
                displayMode : 'markers'
            };
            return options;
        }
     };
});