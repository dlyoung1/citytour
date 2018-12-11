package com.techelevator.model;

import java.util.List;

public interface TripDAO {
	
	public void saveNewTrip(Trip trip);
	public List<Trip> getAllTripsForUser(Integer userId);


}
