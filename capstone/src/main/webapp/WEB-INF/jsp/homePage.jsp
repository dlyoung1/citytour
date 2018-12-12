<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link rel="stylesheet" type="text/css" href="/css/CityTour.css"> 
    
<c:import url="/WEB-INF/jsp/header.jsp" />
    
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/CityTour.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home Page</title>
</head>
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
  max-width: 750px;
  
}

.card-title {
	text-decoration: underline;
	text-decoration-color: white;
}

.wrapper {
  position: relative;
  overflow: hidden;
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
}
.highlight {
	background-color: white;
	opacity: 0.8;
	border-radius: 12px;
	padding: 6px;
	
}
.btn {
	margin-top: 10px;
}


</style>

<div class="card w-75 bg-light text-center border border-dark">
  <c:url var="imgcitygifSrc" value="/img/citygif.gif" /> 
  <div class="wrapper">
  <img class="card-img" src="${imgcitygifSrc}" alt="Card image" style="opacity: 0.35;">
  <div class="card-img-overlay">
    <h2 class="card-title"><strong>Are you looking to maximize your time in a new city?</strong></h2><hr><br>
    <p class="card-text"><span class="highlight">Let <span style="font-family: 'Special Elite', cursive;
					font-size: 18px; font-weight: bold">&nbsp;City Tour&nbsp;</span> help you plan the most efficient route to see as many local landmarks as possible!</span></p>
    <br>
    <form>
		<input type="text" name="cityZipCode" placeholder="Enter City Name or Zip Code"><br>
	</form>
	<a href="#" class="btn btn-warning">Let's Get Started!</a>
  </div>
   </div>
</div>

</body>
</html>
<c:import url="/WEB-INF/jsp/footer.jsp" />