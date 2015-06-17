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
