<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

    <script>
        var infowindow;
        function initMap() {
            var map = new google.maps.Map(document.getElementById('map'), {
                mapTypeControl: false,
                center: { lat: 39.1031, lng: -84.5120 },
                zoom: 13
            });
            new AutocompleteDirectionsHandler(map);
        }

        function AutocompleteDirectionsHandler(map) {
            this.map = map;
            this.originPlaceId = null;
            this.destinationPlaceId = null;
            this.travelMode = 'WALKING';
            var originInput = document.getElementById('origin-input');
            var destinationInput = document.getElementById('destination-input');
            var modeSelector = document.getElementById('mode-selector');
            this.directionsService = new google.maps.DirectionsService;
            this.directionsDisplay = new google.maps.DirectionsRenderer;
            this.directionsDisplay.setMap(map);

            var originAutocomplete = new google.maps.places.Autocomplete(
                originInput, { placeIdOnly: true });
            var destinationAutocomplete = new google.maps.places.Autocomplete(
                destinationInput, { placeIdOnly: true });

            this.setupClickListener('changemode-walking', 'WALKING');
            this.setupClickListener('changemode-transit', 'TRANSIT');
            this.setupClickListener('changemode-driving', 'DRIVING');

            this.setupPlaceChangedListener(originAutocomplete, 'ORIG');
            this.setupPlaceChangedListener(destinationAutocomplete, 'DEST');

        }

        AutocompleteDirectionsHandler.prototype.setupClickListener = function(id, mode) {
            var radioButton = document.getElementById(id);
            var me = this;
            radioButton.addEventListener('click', function() {
                me.travelMode = mode;
                me.route();
            });
        };

        AutocompleteDirectionsHandler.prototype.setupPlaceChangedListener = function(autocomplete, mode) {
            var me = this;
            autocomplete.bindTo('bounds', this.map);
            autocomplete.addListener('place_changed', function () {
                var place = autocomplete.getPlace();
                if(!place.place_id) {
                    window.alert("Please select an option from the dropdown list.");
                    return;
                }
                if(mode === 'ORIG') {
                    me.originPlaceId = place.place_id;
                } else {
                    me.destinationPlaceId = place.place_id;
                }
                me.route();
            });

        };

        AutocompleteDirectionsHandler.prototype.route = function() {
            if (!this.originPlaceId || !this.destinationPlaceId) {
                return;
            }
            var me = this;

            this.directionsService.route({
                origin: { 'placeId': this.originPlaceId },
                destination: { 'placeId': this.destinationPlaceId },
                travelMode: this.travelMode
            }, function (response, status) {
                if (status === 'OK') {
                    me.directionsDisplay.setDirections(response);

                    document.getElementById('startlat').innerHTML = response.routes[0].legs[0].start_location.lat();
                    document.getElementById('startlng').innerHTML = response.routes[0].legs[0].start_location.lng();
                    document.getElementById('endlat').innerHTML = response.routes[0].legs[0].end_location.lat();
                    document.getElementById('endlng').innerHTML = response.routes[0].legs[0].end_location.lng();


                } else {
                    window.alert('Directions request failed due to ' + status);
                }
            });
        };
    </script>
    
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
    
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initMap"
        async defer></script>

<c:import url="/WEB-INF/jsp/footer.jsp" />