<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<div class="container">

	<div class="jumbotron">
		<h1 class="display-4">Hello, world!</h1>
		<p class="lead">This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>
		<hr class="my-4">
		<p>It uses utility classes for typography and spacing to space content out within the larger container.</p>
		<c:forEach var="trip" items="${tripList}">
			<div class="alert alert-dark" role="alert">
				<h4 class="alert-heading">${trip.tripName}</h4>
				<a class="btn btn-primary" href="#" role="button">Edit Trip</a>
				<a class="btn btn-danger" href="#" role="button">Delete Trip</a>
				<hr>
				<p><b>Destination:</b> ${trip.tripCityZipCode} • <b>Creation Date:</b> ${trip.createDate} • <b>Departure Date:</b> ${trip.departureDate}</p>
			</div>
		</c:forEach>
	</div>

</div>

<c:import url="/WEB-INF/jsp/footer.jsp" />





