package com.techelevator.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomePageController {
	
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
}