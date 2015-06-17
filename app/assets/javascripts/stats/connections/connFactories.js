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

var icecast = angular.module("connFactories", ['timeFactory']);

icecast.factory("GroupedChartDataProvider", function (CONNECTIONS, GROUP_BY, SecondsConverter) {
		 return {
				 provide : function(groupBy, datos, columnDescription) {
					if (groupBy == GROUP_BY.YEAR || groupBy == GROUP_BY.MONTH) {
						var data = new google.visualization.DataTable();
						data.addColumn({ type: 'string', label: (groupBy.charAt(0).toUpperCase() + groupBy.slice(1)) });
						data.addColumn({ type: 'number', label: columnDescription });
						var totalSeconds = (CONNECTIONS.TOTAL_SECONDS == columnDescription);
						if (totalSeconds) {
							data.addColumn({type: 'string', role: 'tooltip'});
						}
						for(var i=0; i < datos.length; i++) {
							 if (groupBy == GROUP_BY.YEAR) {
							 		 var year =  datos[i]._id.year.toString();
							 		 !totalSeconds ? data.addRow([year, datos[i].count]) :
							 		 		data.addRow([year, datos[i].count, columnDescription + ': ' + SecondsConverter.toStringSeconds(datos[i].count)]);
							 } else {
							 		var month = datos[i]._id.month.toString();
							 		var year = datos[i]._id.year.toString();
							 		!totalSeconds ? data.addRow([month + "/" + year, datos[i].count]) :
							 			data.addRow([month + "/" + year, datos[i].count, columnDescription + ': ' + SecondsConverter.toStringSeconds(datos[i].count)]);

							 }
						}
						return data;
					} else if (groupBy == GROUP_BY.DAY) {
						data = new google.visualization.DataTable();
						data.addColumn({ type: 'date', label: (groupBy.charAt(0).toUpperCase() + groupBy.slice(1)) });
						data.addColumn({ type: 'number', label: columnDescription });
						var totalSeconds = (CONNECTIONS.TOTAL_SECONDS == columnDescription);
						if (totalSeconds) {
							data.addColumn({type: 'string', role: 'tooltip'});
						}
						for(var i=0; i < datos.length; i++) {
							 var date = new Date(datos[i]._id.year, datos[i]._id.month - 1, datos[i]._id.day);
							 !totalSeconds ? data.addRow([date, datos[i].count]) :
							 	data.addRow([date, datos[i].count, columnDescription + ': ' + SecondsConverter.toStringSeconds(datos[i].count)]);
						}
						return data;
					}
				}
		 };
});

icecast.factory("ConnBetDatesOptionsProvider", function(GROUP_BY) {
		 return {
				 provide : function(groupBy) {
					if (groupBy == GROUP_BY.YEAR) {
						var options = {
							title: 'Oyentes agrupados por año',
							chartArea: {width: '70%', height:'70%'},
							hAxis: {
								title: 'Oyentes',
								minValue: 0
							},
							animation: {
								duration: 1000,
								easing: 'in',
								startup: true
							},
							vAxis: {
								title: 'Año'
							},
							bar: { groupWidth: "90%" }
						};
						return options;
					} else if (groupBy == GROUP_BY.MONTH) {
						var options = {
							title: 'Oyentes agrupados por mes',
							chartArea: {width: '60%', height:'70%'},
							animation: {
								duration: 1000,
								easing: 'in',
								startup: true
							},
							vAxis: {
								title: 'Oyentes'
							},
							bar: { groupWidth: "90%" }
						};
						return options;
					} else if (groupBy == GROUP_BY.DAY) {
						var options = {
							title: "Oyentes por día",
							height: 350
						};
						return options;
					}
				}
		 };
});

icecast.factory("RangesDataProvider", function() {
			return {
				 provide : function(datos) {
					var array = [['Rango', 'Porcentaje de conexiones por rango']];
					for(var i=0; i < datos.length; i++) {
						var str = datos[i]._id;
						array.push([str.substr(2, str.length).trim(), datos[i].count]);
					}
					var data = new google.visualization.arrayToDataTable(array);
					return data;
				}
			};
});

icecast.factory("RangesOptionsProvider", function() {
		 return {
				 provide : function() {
					var options = {
						title: 'Porcentaje de conexiones por rango',
						is3D: true,
						chartArea: {width: '50%', height:'60%'}
					};
					return options;
				}
		 };
});

icecast.factory("ProgramsDataProvider", function() {
			return {
				 provide : function(datos, unique) {
					if (unique) {
						var array = [['Programa', 'Oyentes']];
						for(var i=0; i < datos.length; i++) {
							array.push([datos[i]._id, datos[i].listeners]);
						}
						var data = new google.visualization.arrayToDataTable(array);
						return data;
					} else {
						var array = [['Programa', 'Oyentes', 'Tiempo medio de escucha', 'Tiempo total de escucha']];
						for(var i=0; i < datos.length; i++) {
							array.push([datos[i]._id, datos[i].listeners, datos[i].avg / 60, datos[i].time / 3600]);
						}
						var data = new google.visualization.arrayToDataTable(array);
						return data;
					}
				}
			};
});

icecast.factory("ProgramsOptionsProvider", function() {
		 return {
				 provide : function(unique) {
					if (unique) {
						var options = {
						title: 'Oyentes únicos por programa',
							pieHole: 0.4,
						};
						return options;
					} else {
						var options = {
							title : 'Datos de audiencia agrupados por programa',
							vAxis: {title: "Total"},
							hAxis: {title: "Programa"}
							// seriesType: "bars",
						}
						return options;
					}
				}
		 };
});

icecast.factory("GroupedTotalSecondsOptionsProvider", function(GROUP_BY) {
				 return {
				 provide : function(groupBy) {
					if (groupBy == GROUP_BY.YEAR) {
						var options = {
							title: 'Tiempo total agrupado por año',
							subtitle: 'en segundos',
							// hAxis: {
							// 	title: 'Año',
							// 	minValue: 0
							// },
							animation: {
								duration: 1000,
								easing: 'in',
								startup: true
							},
							vAxis: {
								title: 'Segundos'
							},
							curveType: 'function',
							chartArea: {width: '65%', height:'70%'}
						};
						return options;
					} else if (groupBy == GROUP_BY.MONTH) {
						var options = {
							title: 'Tiempo total agrupado por mes',
							subtitle: 'en segundos',
							chartArea: {width: '60%', height:'70%'},
							animation: {
								duration: 1000,
								easing: 'in',
								startup: true
							},
							vAxis: {
								title: 'Segundos'
							}
						};
						return options;
					} else if (groupBy == GROUP_BY.DAY) {
						var options = {
							title: "Tiempo total agrupado por día",
							subtitle: 'en segundos',
							height: 350
						};
						return options;
					}
				}
		 };
});
