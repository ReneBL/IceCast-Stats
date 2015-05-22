var app = angular.module("homeFactories", []);

app.factory("Last24HoursDataProvider", function () {
	return {
		provide : function (datos) {
			data = new google.visualization.DataTable();
            data.addColumn({ type: 'datetime', label: 'Fecha' });
            data.addColumn({ type: 'number', label: 'Oyentes' });
            for (var i = 0; i < datos.length; i++) {
            	var utcToLocal = new Date(datos[i]._id.datetime);
            	data.addRow([utcToLocal, datos[i]._id.listeners]);
            };
            return data;
		}
	}
});

app.factory("Last24HoursOptionsProvider", function () {
	return {
		provide : function () {
			var options = {
                hAxis: {
                  title: 'Fecha/Hora'
                },
                vAxis: {
                  title: 'Oyentes'
                }
            };
        	return options;
		}
	}
});