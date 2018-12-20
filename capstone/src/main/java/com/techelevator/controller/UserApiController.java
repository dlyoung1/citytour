package com.techelevator.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.model.Trip;
import com.techelevator.model.TripDAO;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;

@CrossOrigin(origins = "*")

@RestController
public class UserApiController {
	
	@Autowired
	private UserDAO userDao;
	
	@Autowired
	private TripDAO tripDao;

	@RequestMapping(path="/users/{userName}/getTrips", method=RequestMethod.GET)
	public List<Trip> getAllTripsForUser(@PathVariable String userName, HttpSession session){
		List<Trip> tripList = new ArrayList<Trip>();
		User currentUser = (User)session.getAttribute("currentUser");
		if(currentUser.getUserName().equals(userName)) {
			int userId = userDao.getUserIdByUserName(userName);
			return tripDao.getAllTripsForUser(userId);
		} else {
			return tripList;
		}	
	}

	@RequestMapping(path="/users/{userName}/delete/{tripId}", method=RequestMethod.DELETE)
	public void deleteTripFromDb(@PathVariable int tripId) {
		tripDao.deleteSavedTrip(tripId);
	}

}
