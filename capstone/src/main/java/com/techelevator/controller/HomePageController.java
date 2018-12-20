package com.techelevator.controller;

import java.time.LocalDateTime;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.techelevator.model.Trip;
import com.techelevator.model.TripDAO;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;

@Controller
public class HomePageController {
	
	private TripDAO tripDAO;
	private UserDAO userDAO;

	@Autowired
	public HomePageController(TripDAO tripDAO, UserDAO userDAO) {
		this.tripDAO = tripDAO;
		this.userDAO = userDAO;
	}
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String viewHomePage(ModelMap map) {
		return "homePage";
	}
	
	@RequestMapping(value="/", method=RequestMethod.POST)
	public String sendPlaceToPlanner(@RequestParam String placeJSON, ModelMap map) {
		map.put("place", placeJSON);
		return "searchPlaces";
	}
	
	@RequestMapping("/searchPlaces")
	public String searchPlaces() {
		return "searchPlaces";
	}
	
	@RequestMapping(value="/route", method=RequestMethod.GET)
	public String displaySavedRoute() {
		return "route";
	}
	
	@RequestMapping(value="/route", method=RequestMethod.POST)
	public String displayNewRoute(@RequestParam String selectedPlaces, @RequestParam String tripName, @RequestParam String startingCity, @RequestParam double startingLat, @RequestParam double startingLng, ModelMap map, HttpSession session) {
		Trip trip = new Trip(LocalDateTime.now(), LocalDateTime.now());
		User currentUser = (User)session.getAttribute("currentUser");
		trip.setUserId(userDAO.getUserIdByUserName(currentUser.getUserName()));
		trip.setTripName(tripName);
		trip.setTripJson(selectedPlaces);
		trip.setTripFormattedAddress(startingCity);
		trip.setTripLatitude(startingLat);
		trip.setTripLongitude(startingLng);
		tripDAO.saveNewTrip(trip);
		map.put("newTripJSON", selectedPlaces);
		return "route";
	}
}