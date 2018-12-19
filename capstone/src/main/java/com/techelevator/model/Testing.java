package com.techelevator.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
		newTrip.setCreateDate(LocalDateTime.now());
		newTrip.setTripCityZipCode(45069);
		newTrip.setTripCity("West Chester");
		newTrip.setTripCountry("USA");
		newTrip.setTripFormattedAddress("West Chester Township, OH 45069, USA");
		newTrip.setTripName("My Second Trip!");
		newTrip.setUserId(1);
		
		Place place1 = new Place();
		Place place2 = new Place();
		Place place3 = new Place();
		place1.setDescription("SOME NEW TEXT");
		place1.setLatitude("500.1212412");
		place1.setLongitude("350.124152");
		place1.setPlaceName("New Place 1");
		place2.setDescription("SOME NEW TEXT");
		place2.setLatitude("89.1212412");
		place2.setLongitude("100.124152");
		place2.setPlaceName("New Place 2");
		place3.setDescription("SOME NEW TEXT");
		place3.setLatitude("400.1212412");
		place3.setLongitude("32.124152");
		place3.setPlaceName("New Place 3");
		List<Place> places = new ArrayList<Place>();
		places.add(place1);
		places.add(place2);
		places.add(place3);
		newTrip.setTripStops(places);
		
		jdbcTripDao.saveNewTrip(newTrip);
		
		
	}

}
