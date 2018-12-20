<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<style>
input[type=text] {
	width: 50%;
	padding: 12px 10px;
	box-sizing: border-box;
}
#homePageCard {
	background-color: rgb(25, 25, 25);
	opacity: 0.8;
}
.card {
	margin: 0 auto;
	margin-top: 40px;
	float: none;
	margin-bottom: 50px;
	word-wrap: break-word;
	max-width: 700px;
}

.container {
	margin-bottom: 40px;
}

h2 {
	font-family: 'Special Elite', cursive;
	font-size: 30px;
}

h5 {
	font-family: 'Special Elite', cursive;
}

.wrapper {
	position: relative;
	max-height: 400px;
}

.wrapper:after {
	content: '';
	display: block;
	padding-top: 100%;
}

.wrapper img {
	width: 100%;
	height: 100%;
	max-width: none;
	position: absolute;
	left: 50%;
	top: 0;
	transform: translateX(-50%);
}

hr {
	display: block;
	margin-top: 0.5em;
	margin-bottom: 0.5em;
	margin-left: auto;
	margin-right: auto;
	border-style: inset;
	border-width: 1.5px;
}

.card-text {
	font-size: 18px;
	background-color: white;
	opacity: 0.8;
	padding: 6px;
	border-radius: 10px;
}

.btn {
	margin-top: 10px;
}

.discoverMoreLink {
	color: white;
	text-decoration: underline;
}

.card-img-overlay {
	overflow: auto;
}
.card-columns {
	margin-top: 10px;
	margin-left: 60px;
	margin-right: 60px;
	margin-bottom: 100px;
}

.rotate {
	-webkit-transform: rotate(-50deg);
	-moz-transform: rotate(-50deg);
	-ms-transform: rotate(-50deg);
	-o-transform: rotate(-50deg);
	transform: rotate(-50deg);
}
.center {
	display: block;
	margin-left: auto;
	margin-right: auto;
}

.card-columns { @include media-breakpoint-only(lg) { column-count:4;
	
}
</style>


<script type="text/javascript">
	$(document).ready(
			function() {
				var input = document.getElementById('cityZipCode');
				var options = {
					types : [ '(regions)' ]
				};
				var autocomplete = new google.maps.places.Autocomplete(input,
						options);
				google.maps.event.addListener(autocomplete, 'place_changed',
						function() {
							var place = autocomplete.getPlace();
							$("#placeJSON").val(
									encodeURIComponent(JSON.stringify(place)));
						})

						$('#cityZipCode').keydown(function (e) {
				  			if (e.which == 13 && $('.pac-container:visible').length) {
				  				e.preventDefault();
				  				$("#cityForm").submit();
				  			}
						});

			})
</script>

<div id="homePageCard" class="card w-75 text-center border border-dark">
	<c:url var="imgcitygifSrc" value="/img/citygif.gif" />
	<div class="wrapper">
		<%-- <img class="card-img grayscale" src="${imgcitygifSrc}" alt="Card image"> --%>
		<div class="card-img-overlay">
			<h2 class="card-title" style="color:white">Are you looking to maximize your time in
				a new city?</h2>
			<hr>
			<br>
			<p class="card-text">
				<span class="highlight">Let <span
					style="font-family: 'Special Elite', cursive; font-size: 18px; font-weight: bold">City
						Tour</span> help you plan the most efficient route to see as many
					local landmarks as possible!
				</span>
			</p>
			<br>
			<c:url value="/" var="formAction" />
			<form method="POST" action="${formAction}">
				<input type="text" name="cityZipCode"
					placeholder="Enter City Name or Zip Code" id="cityZipCode"><br>
				<input type="hidden" value="" name="placeJSON" id="placeJSON">
				<input type="submit" class="btn btn-warning" id="submitButton"
					value="Let's Get Started!" style="margin-bottom: 5px">
			</form>
			<a href="#discoverMore" style="color: white">or Discover More</a>
		</div>
	</div>
</div>
<div class="container">
	<c:url var="arrow" value="/img/curlyarrow.png" />
	<img src="${arrow}" alt="curly arrow" class="moveImg rotate center"
		height="300">
</div>
<div id="discoverMore" class="card-columns">
	<div class="card">
		<c:url var="keyWestImg" value="/img/keywest.jpg" />
		<img class="card-img-top" src="${keyWestImg}" alt="Card image cap">
		<div class="card-body">
			<h5 class="card-title">Travel to Key West!</h5>
			<p class="card-text">Beat the winter blues by getting a dose of
				Vitamin D. You can choose to catch the sunset at Mallory Square or
				eat an authentic piece of Key Lime Pie, either way you can't go
				wrong!</p>
		</div>
	</div>
	<div class="card p-3">
		<blockquote class="blockquote mb-0 card-body">
			<p>
				<span style="font-weight: bold; font-size: 24px;">Did You
					Know?</span> <span style="font-family: 'Special Elite', cursive;">Hampton,
					Virginia</span> was the site of America's first continuous
				English-speaking settlement.
		</blockquote>
	</div>
	<div class="card">
		<c:url var="breckCol" value="/img/breckenridge.jpg" />
		<img class="card-img-top" src="${breckCol}" alt="Card image cap">
		<div class="card-body">
			<h5 class="card-title">Get Cozy in Breckenridge!</h5>
			<p class="card-text">Winter is a perfect time to take advantage
				of activities that rely on Breckenridge’s generous snowfall. Try
				Snowmobiling, Dogsledding and many more winter activities in
				Breckenridge!</p>
		</div>
	</div>
	<div class="card bg-warning text-white text-center p-3">
		<blockquote class="blockquote mb-0">
			<p style="font-family: 'Special Elite', cursive; font-size: 30px">What
				will your next adventure be?</p>
		</blockquote>
	</div>
	<div class="card">
		<c:url var="lasVegasImg" value="/img/lasvegas.jpg" />
		<img class="card-img-top" src="${lasVegasImg}" alt="Card image cap">
		<div class="card-body">
			<h5 class="card-title">Vegas is Calling Your Name!</h5>
			<p class="card-text">With the Las Vegas Strip offering more than 4 miles worth
				of fun, why would you not answer?!?</p>
		</div>
	</div>
	<div class="card">
		<c:url var="Arizona" value="/img/Arizona.jpg" />
		<img class="card-img" src="${Arizona}" alt="Card image">
	</div>
	<div class="card p-3 text-right">
		<blockquote class="blockquote mb-0">
			<p>
				Have you always wanted to visit <span
					style="font-weight: bold; font-size: 22px; font-family: 'Special Elite', cursive;">Arizona</span>
				without the blistering heat? With temperatures averaging in the mid
				<span style="font-weight: bold">70s,</span> now's your chance!
			</p>
		</blockquote>
	</div>
	<div class="card">
		<div class="card-body">
			<span style="font-weight: bold; font-size: 24px;">Looking for
				one of the best beer scenes in America?</span>
			<p class="card-text">
				<span style="font-family: 'Special Elite', cursive;">Asheville,
					North Carolina</span>has got you covered! With over 60 breweries, no
				wonder it has been voted best beer city 4 years in a row.
			</p>
		</div>
	</div>
</div>

<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places"
	defer></script>


<c:import url="/WEB-INF/jsp/footer.jsp" />