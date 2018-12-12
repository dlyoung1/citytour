package com.techelevator.model;

import java.time.LocalDateTime;

import org.apache.commons.dbcp2.BasicDataSource;

import com.techelevator.model.jdbc.JDBCTripDAO;

public class Testing {
	
	public static void main(String[] args) {
		
		BasicDataSource capstoneSource = new BasicDataSource();
		capstoneSource.setUrl("jdbc:postgresql://localhost:5432/capstone");
		capstoneSource.setUsername("postgres");
		capstoneSource.setPassword("postgres1");
		
		JDBCTripDAO jdbcTripDao = new JDBCTripDAO(capstoneSource);
		
		Trip newTrip = new Trip();
		newTrip.setDepartureDate(LocalDateTime.now());
		newTrip.setExploreRadius(110);
		newTrip.setLastEditDate(LocalDateTime.now());
		newTrip.setTripCityZipCode(45069);
		newTrip.setTripName("My Updated Trip");
		
		Place place1 = new Place();
		Place place2 = new Place();
		Place place3 = new Place();
		place1.setDescription("SOME NEW TEXT");
		place1.setLatitude("500.1212412");
		place1.setLongitude("350.124152");
		place1.setPlaceName("New Place 1");
		
	}

}
