/*We need to manually start angular as we need to
wait for the google charting libs to be ready*/  
google.setOnLoadCallback(function () {  
    angular.bootstrap(document.body, ['icecastStats']);
});
