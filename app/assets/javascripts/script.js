function print_column_chart( datos ) {
   var data = new google.visualization.DataTable();
	   data.addColumn('number', 'Months');
	   data.addColumn('number', 'Listeners');
	   for (i = 0; i < datos.length -1; i++) {
	   	   data.addRow([datos[i]._id.month, datos[i].count]);	   	   
	   }
	   var options = {
        width: 1000,
        height: 563,
        hAxis: {
          title: 'Months',
        },
        vAxis: {
          title: 'Number of listeners'
        }
      };
   var chart = new google.visualization.ColumnChart(document.getElementById('month_per_year'));

   chart.draw(data, options);
}

function print_bar_chart( datos ) {
	   var array = [
	       ["Year", "Listeners"],
	       [datos[0]._id.year.toString(), datos[0].count],
	       [datos[1]._id.year.toString(), datos[1].count]
	   ];
	   var data = new google.visualization.arrayToDataTable(array);
	   var options = {
	   	   title : 'Number of connections per year',
	   	   animation : {
	   	   	   duration : 5000,
	   	   	   startup : 'true',
	   	   	   easing : 'linear'
	   	   },
	   	   legend: { position: 'none' },
	   	   chart: { 
	   	   	   title: 'Connections',
         subtitle: 'amount per year' 
      },
      bars : 'horizontal',
      axes: {
            x: {
              0: { side: 'top', label: 'Listeners'} // Top x-axis.
            }
          },
          bar: { groupWidth: "90%" }
	   };
   var chart = new google.charts.Bar(document.getElementById('chart'));
   chart.draw(data, options);
}

function months_year_chart() {
	   $.ajax({
       type: "GET",
       			url: "/connections/months/" + $("#years :selected").text(),
       			dataType: "json",
       			success: function ( data ) {
            			print_column_chart(data);
         }
       }
   );
}

function year_chart() {
	   $.ajax({
       type: "GET",
       			url: "/connections",
       			dataType: "json",
       			success: function ( data ) {
            			print_bar_chart(data);
         }
       }
   );
}

function get_data() {
	   year_chart();
	   //months_year_chart();
}

function populateSelect() {
	   $.ajax(
	   	  {type : "GET", url: "connections/years", async : false, dataType: "json",
	   	   success: function ( data ) {
	   	     $.each(data, function (key, value) {
	   	     	  if (key == 0) {
	   	     	  	  $("#years").append($("<option selected=\"selected\">"+this._id.year+"</option>"));
	   	     	  } else {
	   	     	  	  $("#years").append($("<option>"+this._id.year+"</option>"));
	   	     	  }
	   	     })	;
	   	   }
	   	  }
	  );
}

$(document).ready(function() {
	    $.when(populateSelect()).done(	months_year_chart());
    $("#target").click( function() {
    	    $("#chart").empty();
        get_data();     
      }
    );
    $("#years").change(function() {
    	   $("#month_per_year").empty();
    	   months_year_chart();
    });
});