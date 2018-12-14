<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- COMMENTED OUT <link rel="stylesheet" type="text/css" href="/css/CityTour.css">  -->
    
<c:import url="/WEB-INF/jsp/header.jsp" />

<style>
input[type=text] {
	width: 50%;
	padding: 12px 10px;
	box-sizing: border-box;
}

.card {
	margin: 0 auto;
	margin-top: 40px;
	float: none;
	margin-bottom: 50px;
	word-wrap: break-word;
	max-width: 700px;
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

img {
	opacity: 0.8;
}

.card-columns {
	margin-left: 60px;
	margin-right: 60px;
	margin-bottom: 100px;
}

.card-columns { @include media-breakpoint-only(lg) { column-count:4;
	
}

@
include media-breakpoint-only (xl ) {
	column-count: 5;
}
}
</style>


<script type="text/javascript">
	$(document).ready(function () {
		var input = document.getElementById('cityZipCode');
		var options = {
			types: ['(regions)']
		};
		var autocomplete = new google.maps.places.Autocomplete(input, options);
		google.maps.event.addListener(autocomplete, 'place_changed', function(){
			var place = autocomplete.getPlace();
			$("#placeJSON").val(encodeURIComponent(JSON.stringify(place)));
		})
		
/* 	$("#submitButton").on("click", function(e) {
			var root = "http://localhost:8080/capstone/";
			var place = autocomplete.getPlace();
	        $.ajax({
	            method: "POST",
	            url: root,
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            data: JSON.stringify(place),
	            success: function (response) {
	                if (response.d == true) {
	                     window.location = root + "searchPlaces";
	                 }
	             },
	             failure: function (response) {
	                 alert(response.d);
	             }
	        })
	        e.preventDefault();
			return false;
	    }) */
	      
	})
</script>

<div class="card w-75 bg-light text-center border border-dark">
	<c:url var="imgcitygifSrc" value="/img/citygif.gif" />
	<div class="wrapper">
		<img class="card-img grayscale" src="${imgcitygifSrc}"
			alt="Card image" style="opacity: 0.8;">
		<div class="card-img-overlay">
			<h2 class="card-title">
				<strong>Looking to maximize your time in a new city?</strong>
			</h2>
			<hr>
			<br>
			<p class="card-text">
				Let <span
					style="font-family: 'Special Elite', cursive; font-size: 18px; font-weight: bold">&nbsp;City
					Tour&nbsp;</span> help you plan the most efficient route to see as many
				local landmarks as possible!
			</p>
			<br>
			<form>
				<input type="text" name="cityZipCode"
					placeholder="Enter City Name or Zip Code"><br>
			</form>
			<c:url var="searchPlacesHref" value="/searchPlaces" />
			<a href="${searchPlacesHref}" class="btn btn-warning"
				style="display: inline">Let's Get Started!</a>
			<p>
				<br> <a href="#discoverMore" class="discoverMoreLink">or
					Discover More</a>
			</p>
		</div>
	</div>
</div>
<%-- <div class="arrow">
	<c:url var="arrowDashes" value="/img/dashes .jpg"/>
	<img src="${arrowDashes}" alt="arrow img">
</div>	 --%>
<div id="discoverMore" class="card-columns">
	<div class="card">
		<c:url var="keyWestImg" value="/img/keywest.jpg" />
		<img class="card-img-top" src="${keyWestImg}" alt="Card image cap">
		<div class="card-body">
			<h5 class="card-title">Card title that wraps to a new line</h5>
			<p class="card-text">This is a longer card with supporting text
				below as a natural lead-in to additional content. This content is a
				little bit longer.</p>
		</div>
	</div>
	<div class="card p-3">
		<blockquote class="blockquote mb-0 card-body">
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
				Integer posuere erat a ante.</p>
			<footer class="blockquote-footer">
				<small class="text-muted"> Someone famous in <cite
					title="Source Title">Source Title</cite>
				</small>
			</footer>
		</blockquote>
	</div>
	<div class="card">
		<c:url var="breckCol" value="/img/breckenridge.jpg" />
		<img class="card-img-top" src="${breckCol}" alt="Card image cap">
		<div class="card-body">
			<h5 class="card-title">Card title</h5>
			<p class="card-text">This card has supporting text below as a
				natural lead-in to additional content.</p>
			<p class="card-text">
				<small class="text-muted">Last updated 3 mins ago</small>
			</p>
		</div>
	</div>
	<div class="card bg-warning text-white text-center p-3">
		<blockquote class="blockquote mb-0">
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
				Integer posuere erat.</p>
			<footer class="blockquote-footer">
				<small> Someone famous in <cite title="Source Title">Source
						Title</cite>
				</small>
			</footer>
		</blockquote>
	</div>
	<div class="card text-center">
		<div class="card-body">
			<h5 class="card-title">Card title</h5>
			<p class="card-text">This card has supporting text below as a
				natural lead-in to additional content.</p>
			<p class="card-text">
				<small class="text-muted">Last updated 3 mins ago</small>
			</p>
		</div>
	</div>
	<div class="card">
		<c:url var="Arizona" value="/img/Arizona.jpg" />
		<img class="card-img" src="${Arizona}" alt="Card image">
	</div>
	<div class="card p-3 text-right">
		<blockquote class="blockquote mb-0">
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
				Integer posuere erat a ante.</p>
			<footer class="blockquote-footer">
				<small class="text-muted"> Someone famous in <cite
					title="Source Title">Source Title</cite>
				</small>
			</footer>
		</blockquote>
	</div>
	<div class="card">
		<div class="card-body">
			<h5 class="card-title">Card title</h5>
			<p class="card-text">This is a wider card with supporting text
				below as a natural lead-in to additional content. This card has even
				longer content than the first to show that equal height action.</p>
			<p class="card-text">
				<small class="text-muted">Last updated 3 mins ago</small>
			</p>
		</div>
	</div>
</div>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA7oumI2M6zv0ccOUtWU1aoHqIKp_qD6L8&libraries=places" defer></script>


<c:import url="/WEB-INF/jsp/footer.jsp" />