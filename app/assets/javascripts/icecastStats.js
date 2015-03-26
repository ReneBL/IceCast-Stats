angular.module('icecastStats', ['snap'])
.controller('HomeController', function() {
	  this.hola = 'hola';
	  this.nombre = '';
	  
	  this.saludo = function() {
	  	   return this.hola + ' ' + this.nombre;
	  };
});
