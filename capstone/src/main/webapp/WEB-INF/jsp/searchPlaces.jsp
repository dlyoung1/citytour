<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

<style>
h4 {
	font-family: 'Special Elite', cursive;
	text-decoration: underline;
}

hr {
	margin-top: 10px;
	border-top: 1.5px solid black;
}

li {
	list-style-image: url(img/current-location.png)
}
.card {
	opacity: 0.8;
}
div.container {
	margin: 0 auto;
}
</style>
<c:if test="${not empty place}">
	<div id="placeJSON" data-json='${place}'></div>
</c:if>

<c:if test="${not empty savedTrip}">
	<div id="savedTrip" data-present="true">
	<div id="savedTripFormattedAddress" data-data="${savedTrip.tripFormattedAddress}"></div>
	<div id="savedTripLat" data-data="${savedTrip.tripLatitude}"></div>
	<div id="savedTripLng" data-data="${savedTrip.tripLongitude}"></div>
	</div>
</c:if>

<div class="container">
	
	<div class="row">

		<div class="categoriesCard" style="float: left;">

			<form name="frm_map" id="frm_map">
				<div class="col">
					<div class="card text-center"
						style="width: 250px; height: 500px" id="categories">
						<div class="card-body">
							<input type="hidden" name="address" id="address" value="">

							<h5 class="card-title text-left">
								<span
									style="font-family: 'Special Elite', cursive; font-size: 24px">Radius:</span>
								<select>
									<option id="radius" value="8.04672">5</option>
									<option id="radius" value="16.0934">10</option>
									<option id="radius" value="24.1402">15</option>
									<option id="radius" value="32.1869">20</option>
								</select>

							</h5>
							<h5 class="card-title text-left">
								<span
									style="font-family: 'Special Elite', cursive; font-size: 24px">Categories:</span>
							</h5>
							<div id="type_holder" style="height: 340px; overflow-y: scroll">
							</div>
							<div>
								<input type="button" class="btn btn-warning" value="Show"
									id="submit" onclick="renderMap();"> <input type="reset"
									class="btn btn-warning" value="Reset">
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
				<div class="col">
				<div id="map" style="min-width: 330px; width: 500px; height: 500px;"></div>
			</div>
		

		<div class="col">
			<div class="card text-center placesList"
				style="float: left; background-color: white; overflow-y: scroll; height: 500px; max-width: 330px;"
				id="placeList"></div>
		</div>
</div>
</div>

<div style="float: left; background-color: white">
	<c:url var="addSelection" value="/route" />
	<form name="selected" method="POST" action="${addSelection}">
		<div id="selected"></div>
		<input type="submit" value="add locations">
	</form>
</div> 

	<script>
		$(document)
				.ready(
						function() {

							$("#address")
									.val(placeAddress);
							var html = '';
							var types = [ 'entertainment', 'cultural',
									'night_life', 'sports', 'accomodations',
									'restaurants', 'shopping',
									'outdoor_recreation',
									'public_transportation',
									'medical_services', 'pet_care',
									'other_services', 'spiritual' ];

							$
									.each(
											types,
											function(index, value) {
												var name = value.replace(/_/g,
														" ");
												html += '<div><label><input type="checkbox" class="types" id="' + value + '"value="' + value + '" />'
														+ capitalizeFirstLetter(name)
														+ '</label></div>';
											});
							$('#type_holder').html(html);

						});
		
		var placeAddress;
		var postedPlaceJSON;
		var lat;
		var lng;

		if($("#placeJSON").length != 0) {
			postedPlaceJSON = JSON.parse(decodeURIComponent($("#placeJSON").attr("data-json")));
			placeAddress = postedPlaceJSON.formatted_address;
			lat = postedPlaceJSON.geometry.location.lat;
			lng = postedPlaceJSON.geometry.location.lng;
		} else if($("#savedTrip").length != 0) {
			placeAddress = $("#savedTripFormattedAddress").attr("data-data");
			lat = $("#savedTripLat").attr("data-data");
			lng = $("#savedTripLng").attr("data-data");
		} else {
			placeAddress = 'Cincinnati, OH, USA';
			lat = 39.1031182;
			lng = -84.51201960000003;
		}
		
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
            var place = new google.maps.LatLng(this.lat, this.lng);
            console.log(this.lng);
            map = new google.maps.Map(document.getElementById('map'), {
                center: place,
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
            		var html = '<h4>Location details</h4><ul>';
            		for (var i = 0; i < results.length; i++) {
            			
            			console.log("results[" + i + "]: ", results[i]);
            			
                    createMarker(results[i], results[i].icon);
            			html += '<li class="places" id="' + results[i].name + '" data-value="' + encodeURIComponent(JSON.stringify(results[i])) + '">' + results[i].name + '</li>';
            			html += '<div>' + results[i].vicinity + '</div>';
            			
                }
            		$('#placeList').html(html + '</ul>');
            }
            
            var html = '<h4>Selected location details</h4><ul>';
            $('#placeList li').click(function () {
	    			var selectedPlace = this.dataset.value;
	    			selectedPlace = JSON.parse(decodeURIComponent(selectedPlace));
	    			html += '<li id="' + selectedPlace.name + '">' + selectedPlace.name + '</li>';
	    			html += '<input type="hidden" value="' + encodeURIComponent(JSON.stringify(selectedPlace)) + '" name="selectedPlaces">';
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

            let imageHtml = null
            if(place.photos && place.photos[0]) {
/*             		console.log("Photo URL: ", place.photos[0].getUrl({'maxWidth': 60, 'maxHeight': }))
 */            		const photo="1sCmRaAAAAcr9LKNObgn3M-WmTBQw_1uUlDXvb0-WFntA9YUwT3NOhnQrzWgjCWSK_3a8t5ltU5eJGx2da5xAe_s42aWiC1daKldrEqxlKWNb2MRPOuH_0q0Kn4wI063qTTZhWb0PsEhDNx28qDAMkcvudfmVBew1bGhQGBnKTIoNGlWRFt-QF-pwSS1zE6g&3u5248&5m1&2e1&callback=none&key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8";
/*             		imageHtml = '<img src="https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&photo_reference=' + photo + '" />' + '<br>';
 */           		imageHtml = '<img src="' + place.photos[0].getUrl({'maxWidth': 170, 'maxHeight': 170}) + '" />' + '<br>';
            }
            
            	
            google.maps.event.addListener(marker, 'click', function () {
                infowindow.setContent(imageHtml + place.name + '<br>' + place.vicinity);
                infowindow.open(map, this);
            });
        }
        
    </script>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initialize" async defer></script>

<!-- "<div style='float:left'><img src='https://maps.googleapis.com/maps/api/place/photo?photo_reference=CnRvAAAAwMpdHeWlXl-lH0vp7lez4znKPIWSWvgvZFISdKx45AwJVP1Qp37YOrH7sqHMJ8C-vBDC546decipPHchJhHZL94RcTUfPa1jWzo-rSHaTlbNtjh-N68RkcToUCuY9v2HNpo5mziqkir37WU8FJEqVBIQ4k938TI3e7bf8xq-uwDZcxoUbO_ZJzPxremiQurAYzCTwRhE_V0&key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8'"
 -->

	<c:import url="/WEB-INF/jsp/footer.jsp" />

	<!--  AIzaSyBvlZzcW-vTB5CPn8C63i6_INp0lOvkMdo -->