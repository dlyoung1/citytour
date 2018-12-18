<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

<style>
.container#mapPage {
	margin: 0 auto;
	margin-top: 30px;
	padding-bottom: 20px;
}
</style>

<div id="placeJSON" data-json='${place}'></div>

<div id="mapPage" class="container">
	<div class="col-md-6 col-sm-6" style="display: inline-block;">
		<div id="map" style="width: 800px; height: 500px;"></div>
	</div>

	<div style="float: left;">
		<form name="frm_map" id="frm_map">

			<div class="card text-center bg-light"
				style="width: 20rem; height: 500px">
				<div class="card-body">
					<h5 class="card-title text-left">
						<span
							style="font-family: 'Special Elite', cursive; font-size: 24px">Categories:</span>
					</h5>
					<div id="type_holder" style="height: 380px; overflow-y: scroll;">
					</div>
					<div class="typeButtons">
						<input type="button" class="btn btn-warning" value="Show"
							id="submit" onclick="renderMap();"> <input type="reset"
							class="btn btn-warning" value="Reset">
					</div>
				</div>
			</div>
		</form>
	</div>

	<div style="float: left" id="placeList"></div>

	<div style="float: right">
		<c:url var="addSelection" value="/selection">
			<form name="selected" method="POST" action="${addSelection}">
				<div id="selected"></div>
				<input type="button" value="add locations">
			</form>
		</c:url>
	</div>
</div>



<script>
	$(document)
			.ready(
					function() {

						$("#address").val(postedPlaceJSON.formatted_address);
						var html = '';
						var types = [ 'entertainment', 'cultural',
								'night_life', 'sports', 'accomodations',
								'restaurants', 'shopping',
								'outdoor_recreation', 'public_transportation',
								'medical_services', 'pet_care',
								'other_services', 'spiritual' ];

						$
								.each(
										types,
										function(index, value) {
											var name = value.replace(/_/g, " ");
											html += '<div><label><input type="checkbox" class="types" id="' + value + '"value="' + value + '" />'
													+ capitalizeFirstLetter(name)
													+ '</label></div>';
										});
						$('#type_holder').html(html);

					});

	var postedPlaceJSON = JSON.parse(decodeURIComponent($("#placeJSON").attr(
			"data-json")));
	var lat = postedPlaceJSON.geometry.location.lat;
	var lng = postedPlaceJSON.geometry.location.lng;

	function capitalizeFirstLetter(string) {
		return string.charAt(0).toUpperCase() + string.slice(1);
	}

	var map;
	var infowindow;
	var autocomplete;
	var countryRestrict = {
		'country' : 'in'
	};
	var selectedTypes = [];

	function initialize() {
		autocomplete = new google.maps.places.Autocomplete((document
				.getElementById('address')), {
			types : [ '(regions)' ],
		});
		var place = new google.maps.LatLng(this.lat, this.lng);
		console.log(this.lng);
		map = new google.maps.Map(document.getElementById('map'), {
			center : place,
			zoom : 13
		});
	}

	function renderMap() {
		var address = document.getElementById('address').value;
		var radius = parseInt(document.getElementById('radius').value) * 1000;

		selectedTypes = [];
		if ($('#entertainment').is(':checked')) {
			selectedTypes.push('amusement_park', 'aquarium', 'casino', 'zoo',
					'movie_theater');
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
			selectedTypes.push('clothing_store', 'department_store', 'store',
					'shopping_mall');
		}
		if ($('#outdoor_recreation').is(':checked')) {
			selectedTypes.push('campground', 'park');
		}
		if ($('#public_transportation').is(':checked')) {
			selectedTypes.push('airport', 'bus_station', 'transit_station',
					'train_station');
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
			selectedTypes.push('cemetery', 'church', 'hindu_temple',
					'synagogue', 'mosque');
		}

		var geocoder = new google.maps.Geocoder();
		var selLocLat = 0;
		var selLocLng = 0;

		geocoder.geocode({
			'address' : address
		}, function(results, status) {
			if (status === 'OK') {

				selLocLat = results[0].geometry.location.lat();
				selLocLng = results[0].geometry.location.lng();

				var userLoc = new google.maps.LatLng(selLocLat, selLocLng);

				map = new google.maps.Map(document.getElementById('map'), {
					center : userLoc,
					zoom : 13
				});

				infowindow = new google.maps.InfoWindow();
				var service = new google.maps.places.PlacesService(map);

				for (var i = 0; i < selectedTypes.length; i++) {
					var request = {
						location : userLoc,
						radius : radius,
						type : selectedTypes[i]
					};
					service.nearbySearch(request, callback);
				}
			} else {
				alert('Geocode was not successful for the following reason: '
						+ status);
			}
		});
	}

	function callback(results, status) {

		if (status == google.maps.places.PlacesServiceStatus.OK) {
			var html = '<h4>Nearby location details</h4><ul>';
			for (var i = 0; i < results.length; i++) {
				createMarker(results[i], results[i].icon);
				html += '<li class="places" id="' + results[i].name + '" data-value="' + results[i].name + '">'
						+ results[i].name + '</li>';
				html += '<div>' + results[i].vicinity + '</div>';
			}
			$('#placeList').html(html + '</ul>');
		}

		var html = '<h4>Selected location details</h4><ul>';
		$('#placeList li').click(
				function() {
					var selectedPlace = this.dataset.value;
					html += '<li id="' + selectedPlace + '">' + selectedPlace
							+ '</li>';
					$('#selected').html(html + '</ul>');
				});
	}

	function createMarker(place, icon) {
		var placeLoc = place.geometry.location;

		var marker = new google.maps.Marker({
			map : map,
			position : place.geometry.location,
			icon : {
				url : icon,
				scaledSize : new google.maps.Size(20, 20)
			},
			animation : google.maps.Animation.DROP
		});

		google.maps.event.addListener(marker, 'click', function() {
			infowindow.setContent(place.name + '<br>' + place.vicinity);
			infowindow.open(map, this);
		});
	}
</script>

<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initialize"
	async defer></script>


<c:import url="/WEB-INF/jsp/footer.jsp" />