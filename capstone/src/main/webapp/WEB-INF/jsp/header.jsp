<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>City Tour</title>
<c:url var="bootstrapCss" value="/css/bootstrap.min.css" />
<c:url var="siteCss" value="/css/CityTour.css" />

<c:url var="jQueryJs" value="/js/jquery.min.js" />
<c:url var="jqValidateJs" value="/js/jquery.validate.min.js" />
<c:url var="jqvAddMethJs" value="/js/additional-methods.min.js" />
<c:url var="jqTimeagoJs" value="/js/jquery.timeago.js" />
<c:url var="popperJs" value="/js/popper.min.js" />
<c:url var="bootstrapJs" value="/js/bootstrap.min.js" />

<link rel="stylesheet" type="text/css" href="${bootstrapCss}">
<link rel="stylesheet" type="text/css" href="${siteCss}">
<link href="https://fonts.googleapis.com/css?family=Special+Elite"
	rel="stylesheet">

<script src="${jQueryJs}"></script>
<script src="${jqValidateJs}"></script>
<script src="${jqvAddMethJs}"></script>
<script src="${jqTimeagoJs}"></script>
<script src="${popperJs}"></script>
<script src="${bootstrapJs}"></script>

<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("time.timeago").timeago();

						$("#logoutLink").click(function(event) {
							$("#logoutForm").submit();
						});

						var pathname = window.location.pathname;
						$("nav a[href='" + pathname + "']").parent().addClass(
								"active");

						$.validator.addMethod('capitals', function(thing) {
							return thing.match(/[A-Z]/);
						});
						$("form#register")
								.validate(
										{

											rules : {
												userName : {
													required : true
												},
												password : {
													required : true,
													minlength : 15,
													capitals : true,
												},
												confirmPassword : {
													required : true,
													equalTo : "#password"
												}
											},
											messages : {
												password : {
													minlength : "Password too short, make it at least 15 characters",
													capitals : "Field must contain a capital letter",
												},
												confirmPassword : {
													equalTo : "Passwords do not match"
												}
											},
											errorClass : "error"
										});

						$("form#login").validate({

							rules : {
								userName : {
									required : true
								},
								password : {
									required : true
								}
							},
							messages : {
								confirmPassword : {
									equalTo : "Passwords do not match"
								}
							},
							errorClass : "error"
						});
					});
</script>
<style>
.modal-dialog {
	width: 350px;
}

.form-group {
	width: 100%;
}

h3 {
	font-family: 'Special Elite', cursive;
}
</style>
</head>
<body
	style="background: url(img/roadBackground3.png) no-repeat center center fixed; background-size: cover;">
	<nav class="navbar navbar-expand-sm navbar-light bg-light">
		<a class="navbar-brand" href="#"> <c:url var="homePageHref"
				value="/" /> <c:url var="imgSrc" value="/img/marker3.png" /><a
			href="${homePageHref}"><img src="${imgSrc}" class="img-fluid"
				style="height: 48px;" /></a>
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav mr-auto">
				<c:url var="homePageHref" value="/" />
				<li class="nav-item"><a class="nav-link" href="${homePageHref}"
					style="font-family: 'Special Elite', cursive; font-size: 35px; color: rgb(255, 195, 0); font-weight: bold">City
						Tour</a></li>
				
				<c:if test="${not empty currentUser}">
					<c:url var="dashboardHref" value="/users/${currentUser}" />
					<li class="nav-item"><a class="nav-link"
						href="${dashboardHref}">Completed Trips</a></li>
					<c:url var="newMessageHref"
						value="/users/${currentUser}/messages/new" />
					<li class="nav-item"><a class="nav-link"
						href="${newMessageHref}">Upcoming Trips</a></li>
					<c:url var="sentMessagesHref"
						value="/users/${currentUser}/messages" />
					<li class="nav-item"><a class="nav-link"
						href="${sentMessagesHref}">Sent Messages</a></li>
					<c:url var="changePasswordHref"
						value="/users/${currentUser}/changePassword" />
					<li class="nav-item"><a class="nav-link"
						href="${changePasswordHref}">Change Password</a></li>
				</c:if>
			</ul>
			<ul class="navbar-nav ml-auto">
				<c:choose>
					<c:when test="${empty currentUser}">
						<div class="container">
							<button type="button" class="btn btn-link nav-item"
								data-toggle="modal" data-target="#popUpWindow"
								style="color: black">Log In</button>
							<div class="modal fade" id="popUpWindow">
								<div class="modal-dialog">
									<div class="modal-content">
										<!-- header -->
										<div class="modal-header bg-light">
											<h3 class="modal-title">Login</h3>
											<button type="button" class="close" data-dismiss="modal">&times;</button>
										</div>
										<!-- body -->
										<div class="modal-header">
											<form id="login" method="POST" action="${formAction}">
												<input type="hidden" name="destination"
													value="${param.destination}" /> <input type="hidden"
													name="CSRF_TOKEN" value="${CSRF_TOKEN}" />
												<div class="form-group">
													<label for="userName">User Name: </label> <input
														type="text" id="userName" name="userName"
														placeHolder="User Name" class="form-control" />
												</div>
												<div class="form-group">
													<label for="password">Password: </label> <input
														type="password" id="password" name="password"
														placeHolder="Password" class="form-control" />
												</div>
												<button type="submit" class="btn btn-warning">Login</button>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="container">
							<button type="button" class="btn btn-warning nav-item"
								data-toggle="modal" data-target="#popUpWindow2">Sign Up</button>
							<div class="modal fade" id="popUpWindow2">
								<div class="modal-dialog">
									<div class="modal-content">
										<!-- header -->
										<div class="modal-header bg-light">
											<h3 class="modal-title">Register</h3>
											<button type="button" class="close" data-dismiss="modal">&times;</button>
										</div>
										<!-- body -->
										<div class="modal-header">
											<form id="register" method="POST" action="${formAction}">
												<input type="hidden" name="destination"
													value="${param.destination}" /> <input type="hidden"
													name="CSRF_TOKEN" value="${CSRF_TOKEN}" />
												<div class="form-group">
													<label for="userName">User Name: </label> <input
														type="text" id="userName" name="userName"
														placeHolder="User Name" class="form-control" />
												</div>
												<div class="form-group">
													<label for="password">Password: </label> <input
														type="password" id="password" name="password"
														placeHolder="Password" class="form-control" />
												</div>
												<div class="form-group">
													<label for="confirmPassword">Confirm Password: </label> <input
														type="password" id="confirmPassword"
														name="confirmPassword" placeHolder="Re-Type Password"
														class="form-control" />
												</div>
												<button type="submit" class="btn btn-warning">Create
													User</button>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<c:url var="logoutAction" value="/logout" />
						<form id="logoutForm" action="${logoutAction}" method="POST">
							<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}" />
						</form>
						<li class="nav-item"><a id="logoutLink" href="#">Log Out</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
	</nav>

	<c:if test="${not empty currentUser}">
		<p id="currentUser">Current User: ${currentUser}</p>
	</c:if>