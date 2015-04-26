var icecast = angular.module("connFactories", []);

icecast.factory("ConnBetDatesDataProvider", function() {
	   return {
	   	   provide : function(groupBy, datos) {
	        if (groupBy == 'year' || groupBy == 'month') {
	   	       // Capitalize first letter
	   	       var array = [[groupBy.charAt(0).toUpperCase() + groupBy.slice(1), "Total listeners"]];
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
            title: 'Connections grouped by year',
            hAxis: {
              title: 'Listeners',
              minValue: 0
            },
            animation: {
              duration: 1000,
            	  easing: 'in',
            	  startup: true
            },
            vAxis: {
              title: 'Year'
            },
            bar: { groupWidth: "90%" }
          };
	          return options;
	        } else if (groupBy == 'month') {
	        	  var options = {
            title: 'Connections grouped by month',
            chartArea: {width: '60%'},
            animation: {
            	  duration: 1000,
            	  easing: 'in',
            	  startup: true
            },
            vAxis: {
              title: 'Listeners'
            }
          };
          return options;
	        } else if (groupBy == 'day') {
	          var options = {
            title: "Listeners per day",
            height: 350,
          };
	          return options;
	        }
	      }
	   };
});
