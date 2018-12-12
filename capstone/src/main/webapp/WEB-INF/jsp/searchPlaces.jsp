<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="/WEB-INF/jsp/header.jsp" />

    <script>
    $(document).ready(function(){

        var types = ['accounting','airport','amusement_park','aquarium','art_gallery','atm','bakery','bank','bar','beauty_salon','bicycle_store','book_store','bowling_alley','bus_station','cafe','campground','car_dealer','car_rental','car_repair','car_wash','casino','cemetery','church','city_hall','clothing_store','convenience_store','courthouse','dentist','department_store','doctor','electrician','electronics_store','embassy','fire_station','florist','funeral_home','furniture_store','gas_station','gym','hair_care','hardware_store','hindu_temple','home_goods_store','hospital','insurance_agency','jewelry_store','laundry','lawyer','library','liquor_store','local_government_office','locksmith','lodging','mel_delivery','meal_takeaway','mosque','movie_rental','movie_theater','moving_company','museum','night_club','painter','park','parking','pet_store','pharmacy','physiotherapist','plumber','police','post_office','real_estate_agency','restaurant','roofing_contractor','rv_park','school','shoe_store','shopping_mall','spa','stadium','storage','store','subway_station','synagogue','taxi_stand','train_station','transit_station','travel_agency','university','veterinary_care','zoo'];
        var html = '';

        $.each(types, function( index, value ) {
            var name = value.replace(/_/g, " ");
            html += '<div><label><input type="checkbox" class="types" value="'+ value +'" />'+ capitalizeFirstLetter(name) +'</label></div>';
        });

        $('#type_holder').html(html);
    });

    function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    var map;
    var infowindow;
    var autocomplete;
    var countryRestrict = {'country': 'in'};
    var selectedTypes = [];

    function initialize()
    {
        autocomplete = new google.maps.places.Autocomplete((document.getElementById('address')), {
            types: ['(regions)'],
        });
        
        var cincy = new google.maps.LatLng(39.1031, -84.5120);

        map = new google.maps.Map(document.getElementById('map'), {
            center: cincy,
            zoom: 12
        });
    }

    function renderMap()
    {
        var address = document.getElementById('address').value;
        var radius  = parseInt(document.getElementById('radius').value) * 1000;
        
        selectedTypes = [];
        $('.types').each(function(){
            if($(this).is(':checked'))
            {
                selectedTypes.push($(this).val());
            }
        });

        var geocoder    = new google.maps.Geocoder();
        var selLocLat   = 0;
        var selLocLng   = 0;

        geocoder.geocode({'address': address}, function(results, status) {
            if (status === 'OK')
            {

                selLocLat   = results[0].geometry.location.lat();
                selLocLng   = results[0].geometry.location.lng();

                var cincy = new google.maps.LatLng(selLocLat, selLocLng);

                map = new google.maps.Map(document.getElementById('map'), {
                    center: cincy,
                    zoom: 11
                });

                var request = {
                    location: cincy,
                    radius: radius,
                    types: selectedTypes
                };

                infowindow = new google.maps.InfoWindow();

                var service = new google.maps.places.PlacesService(map);
                service.nearbySearch(request, callback);
            }
            else
            {
                alert('Geocode was not successful for the following reason: ' + status);
            }
        });
    }

    function callback(results, status)
    {
        if (status == google.maps.places.PlacesServiceStatus.OK)
        {
            for (var i = 0; i < results.length; i++)
            {
                createMarker(results[i], results[i].icon);
            }
        }
    }

    function createMarker(place, icon) {
        var placeLoc = place.geometry.location;

        var marker = new google.maps.Marker({
            map: map,
            position: place.geometry.location,
            icon: {
                url: icon,
                scaledSize: new google.maps.Size(20, 20) // pixels
            },
            animation: google.maps.Animation.DROP
        });
        
        google.maps.event.addListener(marker, 'click', function() {
            infowindow.setContent(place.name+ '<br>' +place.vicinity);
            infowindow.open(map, this);
        });
    }
    </script>

<div style="float: right;">
    <div id="map" style="width:900px; height:600px;"></div>
</div>

<div style="float: left; width: 400;">
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
                    <div id="type_holder" style="height: 200px; overflow-y: scroll;">
    
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

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places&callback=initialize" async defer></script>


<c:import url="/WEB-INF/jsp/footer.jsp" />