<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

    <script>
        function initMap() {
        	  var directionsService = new google.maps.DirectionsService();
        	  var directionsDisplay = new google.maps.DirectionsRenderer();
        	  var map = new google.maps.Map(document.getElementById('map'), {
        	    zoom: 13,
        	    center: {lat: 39.1031, lng: -84.5120}
        	  });
        	  directionsDisplay.setMap(map);
        	  var waypts = [];
        	  var origin;
        	  var destination;
        	  var places = $('#places').attr('data-json');
        	  var placesArray = places.split(",");
        	  for (var i = 0; i < placesArray.length; i++) {
        		  let info = JSON.parse(decodeURIComponent(placesArray[i]));
        		  console.log("info: " + info.geometry.location.lng);
        		  if(i == 0) {
        			  origin = info;
        		  } else if(i == placesArray.length - 1) {
        			  destination = info;
        		  } else {
	        	      waypts.push({
	        	        location: info.vicinity,
	        	        stopover: true
	        	      });
        		  }
        	    }
        	  console.log("origin(lat): " + origin.geometry.location.lat + " origin(lng): " + origin.geometry.location.lng);
    		  console.log("destination(lat): " + destination.geometry.location.lat + " destination(lng): " + destination.geometry.location.lng);
    		  console.log("waypts: " + waypts);

        	  directionsService.route({
        	    origin: origin.vicinity,
        	    destination: destination.vicinity,
        	    waypoints: waypts,
        	    optimizeWaypoints: true,
        	    travelMode: 'DRIVING'
        	  }, function(response, status) {
        	    if (status === 'OK') {
        	      directionsDisplay.setDirections(response);
        	      var route = response.routes[0];
        	      var summaryPanel = document.getElementById('directions-panel');
        	      summaryPanel.innerHTML = '';
        	      // For each route, display summary information.
        	      for (var i = 0; i < route.legs.length; i++) {
        	        var routeSegment = i + 1;
        	        summaryPanel.innerHTML += '<b>Route Segment: ' + routeSegment +
        	            '</b><br>';
        	        summaryPanel.innerHTML += route.legs[i].start_address + ' to ';
        	        summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
        	        summaryPanel.innerHTML += route.legs[i].distance.text + '<br><br>';
        	      }
        	    } else {
        	      window.alert('Directions request failed due to ' + status);
        	    }
        	  });
        }
    </script>
    
    <input type="hidden" id="places" data-json="${places}"/>
    
    <div id = "mode-selector" class = "controls">
        <input type = "radio" name = "type" id = "changemode-walking" checked = "checked">
        <label for = "changemode-walking">Walking</label>

        <input type = "radio" name = "type" id = "changemode-transit">
        <label for = "changemode-transit">Transit</label>

        <input type = "radio" name = "type" id = "changemode-driving">
        <label for = "changemode-driving">Driving</label>
    </div>
	
    <div>
        <input id = "origin-input" type = "text" placeholder = "Enter an origin location">
    </div>


    <div>
        <input id = "destination-input" type = "text" placeholder = "Enter a destination location">
    </div>

    <div id = "map" style="width:500px; height:500px"></div>
    <div id="directionsPanel" style="float:right;width:30%;height 100%"></div>
    
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initMap"
        async defer></script>

<c:import url="/WEB-INF/jsp/footer.jsp" />