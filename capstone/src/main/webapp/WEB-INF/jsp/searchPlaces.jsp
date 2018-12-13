<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

    <script>
        $(document).ready(function () {

            var html = '';
            var types = ['entertainment', 'cultural', 'night_life', 'sports', 'accomodations', 'restaurants', 'shopping', 'outdoor_recreation', 'public_transportation', 'medical_services', 'pet_care', 'other_services', 'spiritual'];

            $.each(types, function (index, value) {
                var name = value.replace(/_/g, " ");
                html += '<div><label><input type="checkbox" class="types" id="' + value + '"value="' + value + '" />' + capitalizeFirstLetter(name) + '</label></div>';
            });
            $('#type_holder').html(html);
            
            
        });

        function capitalizeFirstLetter(string) {
            return string.charAt(0).toUpperCase() + string.slice(1);
        }

        var map;
        var infowindow;
        var autocomplete;
        var countryRestrict = { 'country': 'in' };
        var selectedTypes = [];

        function initialize() {
            autocomplete = new google.maps.places.Autocomplete((document.getElementById('address')), {
                types: ['(regions)'],
            });

            var cinci = new google.maps.LatLng(39.1031, -84.5120);

            map = new google.maps.Map(document.getElementById('map'), {
                center: cinci,
                zoom: 13
            });
        }

        function renderMap() {
            var address = document.getElementById('address').value;
            var radius = parseInt(document.getElementById('radius').value) * 1000;

            selectedTypes = [];
            if ($('#entertainment').is(':checked')) {
                selectedTypes.push('amusement_park', 'aquarium', 'casino', 'zoo', 'movie_theater');
            }
            if ($('#cultural').is(':checked')) {
                selectedTypes.push('art_gallery', 'museum');
            }
            if ($('#night_life').is(':checked')) {
                selectedTypes.push('bar', 'night_club');
            }
            if ($('#sports').is(':checked')) {
                selectedTypes.push('stadium');
            }
            if ($('#accomodations').is(':checked')) {
                selectedTypes.push('lodging');
            }
            if ($('#restaurants').is(':checked')) {
                selectedTypes.push('bakery', 'cafe', 'restaurant');
            }
            if ($('#shopping').is(':checked')) {
                selectedTypes.push('clothing_store', 'department_store', 'store', 'shopping_mall');
            }
            if ($('#outdoor_recreation').is(':checked')) {
                selectedTypes.push('campground', 'park');
            }
            if ($('#public_transportation').is(':checked')) {
                selectedTypes.push('airport', 'bus_station', 'transit_station', 'train_station');
            }
            if ($('#medical_services').is(':checked')) {
                selectedTypes.push('dentist', 'doctor', 'hospital');
            }
            if ($('#pet_care').is(':checked')) {
                selectedTypes.push('veterinary_care', 'pet_store');
            }
            if ($('#other_services').is(':checked')) {
                selectedTypes.push('accounting', 'atm', 'bank', 'car_rental');
            }
            if ($('#spiritual').is(':checked')) {
                selectedTypes.push('cemetery', 'church', 'hindu_temple', 'synagogue', 'mosque');
            }

            var geocoder = new google.maps.Geocoder();
            var selLocLat = 0;
            var selLocLng = 0;

            geocoder.geocode({ 'address': address }, function (results, status) {
                if (status === 'OK') {

                    selLocLat = results[0].geometry.location.lat();
                    selLocLng = results[0].geometry.location.lng();

                    var userLoc = new google.maps.LatLng(selLocLat, selLocLng);

                    map = new google.maps.Map(document.getElementById('map'), {
                        center: userLoc,
                        zoom: 13
                    });

                    infowindow = new google.maps.InfoWindow();
                    var service = new google.maps.places.PlacesService(map);

                    for (var i = 0; i < selectedTypes.length; i++) {
                        var request = {
                            location: userLoc,
                            radius: radius,
                            type: selectedTypes[i] 
                        };
                        service.nearbySearch(request, callback);
                    }
                }
                else {
                    alert('Geocode was not successful for the following reason: ' + status);
                }
            });
        }

        function callback(results, status) {

            if (status == google.maps.places.PlacesServiceStatus.OK) {
            		var html = '<h4>Nearby location details</h4><ul>';
            		for (var i = 0; i < results.length; i++) {
                    createMarker(results[i], results[i].icon);
            			html += '<li class="places" id="' + results[i].name + '" data-value="' + results[i].name + '">' + results[i].name + '</li>';
            			html += '<div>' + results[i].vicinity + '</div>';
                }
            		$('#placeList').html(html + '</ul>');
            }
            
            var html = '<h4>Selected location details</h4><ul>';
            $('#placeList li').click(function () {
	    			var selectedPlace = this.dataset.value;
	    			html += '<li id="' + selectedPlace + '">' + selectedPlace + '</li>';
	    			$('#selected').html(html + '</ul>');
    			});
        }

        function createMarker(place, icon) {
            var placeLoc = place.geometry.location;

            var marker = new google.maps.Marker({
                map: map,
                position: place.geometry.location,
                icon: {
                    url: icon,
                    scaledSize: new google.maps.Size(20, 20)
                },
                animation: google.maps.Animation.DROP
            });

            google.maps.event.addListener(marker, 'click', function () {
                infowindow.setContent(place.name + '<br>' + place.vicinity);
                infowindow.open(map, this);
            });
        }
        
		
        
         
    </script>

    <div style="display:inline-block; margin:auto">
        <div id="map" style="width:700px; height:600px;"></div>
    </div>

    <div style="float:left; width: 400;">
        <form name="frm_map" id="frm_map">
            <table>
                <tr>
                    <th>Address</th>
                    <td>
                        <input type="text" name="address" id="address" value="Cincinnati, Ohio">
                    </td>
                </tr>
                <tr>
                    <th>Radius</th>
                    <td>
                        <input type="text" name="radius" id="radius" value="5">
                    </td>
                </tr>
                <tr>
                    <th>Types</th>
                    <td>
                        <div id="type_holder" style="height: 250px; overflow-y: scroll;">

                        </div>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" value="Show" id="submit" onclick="renderMap();">
                        <input type="reset" value="Reset">
                    </td>
                </tr>
            </table>
        </form>
        	</div>
        	
        	<div style="float:left" id="placeList"></div>
        	
        	<div style="float:right">
        		<form name="selected" action="POST">
        			<div id="selected"></div>
   				<input type="button" value="add locations">
        		</form>
        	</div>

    

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initialize" async defer></script>


<c:import url="/WEB-INF/jsp/footer.jsp" />