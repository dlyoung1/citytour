package com.techelevator.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.techelevator.model.Trip;
import com.techelevator.model.TripDAO;

@Controller
public class HomePageController {
	
	private TripDAO tripDAO;

	@Autowired
	public HomePageController(TripDAO tripDAO) {
		this.tripDAO = tripDAO;
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
	public String displayNewRoute(@RequestParam String selectedPlaces, ModelMap map) {
		Trip trip = new Trip(LocalDateTime.now(), LocalDateTime.now());
		trip.setUserId(1);
		trip.setTripJson(selectedPlaces);
		trip.setUserId(1);
		trip.setTripFormattedAddress("Cincinnati, OH, USA");
		trip.setTripLatitude(39.1031182);
		trip.setTripLongitude(-84.51201960000003);
		tripDAO.saveNewTrip(trip);
		map.put("newTripJSON", selectedPlaces);
		return "route";
	}
}