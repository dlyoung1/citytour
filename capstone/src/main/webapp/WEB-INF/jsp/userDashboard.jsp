<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<c:url value="/users/${currentUser.userName}" var="rootUrl" />

<div class="container">

	<div class="jumbotron">
		<h1 class="display-4">My Saved Trips</h1>
		<p class="lead">Edit and Delete your saved trips here</p>
		<hr class="my-4">
		<div id="userTrips">
		</div>
	</div>

</div>

<script>
	var root = "${rootUrl}"
	var userName = "${currentUser.userName}"

	$(function () {
	    loadTrips();  
	});

	function loadTrips() {
	    $.ajax({
	        url: root + '/getTrips',
	        method: 'GET'
	    }).done(function (data) {
	        $("#userTrips").empty();
			if(userName == '') {
	            $("#userTrips").append('<p>Please Log in</p>');
			} else if(data.length < 1) {
	            $("#userTrips").append("<p>You don't have any trips saved!</p>");
			} else {
		        for (var i = 0; i < data.length; i++) {
		        		var tripId = data[i].tripId;
		        		var tripName = data[i].tripName;
		        		var destination = data[i].tripFormattedAddress;
		        		var createDate = data[i].createDateString;
		        		var departureDate = data[i].departureDateString;
		            $("#userTrips").append(
						'<div class="alert alert-dark" role="alert" data-tripId="' + tripId + '">' +
						'<h4 class="alert-heading">'+ tripName + '</h4>' +
						'<form method="POST" action="'+root+"/edit?tripId="+tripId+'">' +
						'<input type="submit" class="btn btn-primary" value="Route Trip" role="button" id="editTrip' + tripId + '">' +
						'<a class="btn btn-danger" href="#" role="button" id="deleteTrip' + tripId + '">Delete Trip</a>' +
						'</form>' +
						'<hr>' +
						'<p><b>Destination: </b>' + destination + ' • <b>Departure Date: </b> ' + departureDate + ' • <b>Creation Date: </b>' + createDate + '</p>' +
						'</div>');
		
		            $("#deleteTrip"+tripId).on("click", onDeleteButtonClick);
		        	}
			}
	    });
	}

	function onDeleteButtonClick(e) {
	    var tripSelector = e.target.id;
	    var tripId = tripSelector.replace("deleteTrip", "");
	    $.ajax({
	        url: root + '/delete/' + tripId,
	        method: 'DELETE'
	    }).done(function (data) {
	        loadTrips();
	    });
	}

</script>

<c:import url="/WEB-INF/jsp/footer.jsp" />





