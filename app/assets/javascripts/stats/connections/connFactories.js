var icecast = angular.module("connFactories", []);

icecast.factory("GroupedChartDataProvider", function() {
	   return {
	   	   provide : function(groupBy, datos, columnDescription) {
	        if (groupBy == 'year' || groupBy == 'month') {
	   	       // Capitalize first letter
	   	       var array = [[groupBy.charAt(0).toUpperCase() + groupBy.slice(1), columnDescription]];
	          for(var i=0; i < datos.length; i++) {
	     	       groupBy == 'year' ? array.push([datos[i]._id.year.toString(), datos[i].count]) : 
	     	          array.push([datos[i]._id.month.toString() + "/" + datos[i]._id.year.toString(), datos[i].count]);
	          }
	          var dt = new google.visualization.arrayToDataTable(array);
	          return dt;
	        } else if (groupBy == 'day') {
	   	      data = new google.visualization.DataTable();
            data.addColumn({ type: 'date', id: 'Date' });
            data.addColumn({ type: 'number', id: 'Listeners' });
            for(var i=0; i < datos.length; i++) {
	   	         data.addRow([new Date(datos[i]._id.year, datos[i]._id.month - 1, datos[i]._id.day), datos[i].count]);
	          }
	          return data;
	        }
	      }
	   };
});

icecast.factory("ConnBetDatesOptionsProvider", function() {
	   return {
	   	   provide : function(groupBy) {
	        if (groupBy == 'year') {
	        	var options = {
            	title: 'Oyentes agrupados por año',
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
	        } else if (groupBy == 'month') {
	        	var options = {
            	title: 'Oyentes agrupados por mes',
            	chartArea: {width: '60%', height: '150%'},
            	animation: {
            	  duration: 1000,
            	  easing: 'in',
            	  startup: true
            	},
            	vAxis: {
              	title: 'Oyentes'
            	}
          	};
          	return options;
	        } else if (groupBy == 'day') {
	          var options = {
            	title: "Oyentes por día",
            	height: 350,
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

icecast.factory("GroupedTotalSecondsOptionsProvider", function() {
         return {
         provide : function(groupBy) {
          if (groupBy == 'year') {
            var options = {
              title: 'Tiempo total agrupado por año',
              subtitle: 'en segundos',
              hAxis: {
                title: 'Año',
                minValue: 0
              },
              animation: {
                duration: 1000,
                easing: 'in',
                startup: true
              },
              vAxis: {
                title: 'Segundos'
              },
              curveType: 'function',
              chartArea:{width:'75%', height:'75%'}
            };
            return options;
          } else if (groupBy == 'month') {
            var options = {
              title: 'Tiempo total agrupado por mes',
              subtitle: 'en segundos',
              chartArea: {width: '60%', height:'75%'},
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
          } else if (groupBy == 'day') {
            var options = {
              title: "Tiempo total agrupado por día",
              subtitle: 'en segundos',
              height: 350,
            };
            return options;
          }
        }
     };
});
