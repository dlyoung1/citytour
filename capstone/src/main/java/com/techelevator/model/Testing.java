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
		
		Trip newTrip = new Trip(LocalDateTime.now(), LocalDateTime.now());
		newTrip.setExploreRadius(5);
		newTrip.setLastEditDate(LocalDateTime.now());
		//newTrip.setTripCityZipCode();
		newTrip.setTripLatitude(39.1031182);
		newTrip.setTripLongitude(-84.51201960000003);
		newTrip.setTripCity("Cincinnati");
		newTrip.setTripCountry("USA");
		newTrip.setTripFormattedAddress("Cincinnati, OH, USA");
		newTrip.setTripName("My Short Cincinnati Trip!");
		newTrip.setUserId(1);
		
		Place place1 = new Place();
		Place place2 = new Place();
		Place place3 = new Place();
		place1.setDescription("Bar Description");
		 
		place1.setLatitude("39.106278");
		place1.setLongitude("-84.515305");
		place1.setPlaceName("Queen City Exchange");
		place2.setDescription("School Description");
		place2.setLatitude("39.108872");
		place2.setLongitude("-84.513876");
		place2.setPlaceName("Art Academy of Cincinnati");
		place3.setDescription("Museum Description");
		place3.setLatitude("39.108657");
		place3.setLongitude("-84.509313");
		place3.setPlaceName("Greater Cincinnati Police Museum");
		List<Place> places1 = new ArrayList<Place>();
		places1.add(place1);
		places1.add(place2);
		places1.add(place3);
		newTrip.setTripStops(places1);
		
		jdbcTripDao.saveNewTrip(newTrip);
		
		Trip newTrip1 = new Trip(LocalDateTime.now(), LocalDateTime.now());
		newTrip1.setExploreRadius(5);
		newTrip1.setLastEditDate(LocalDateTime.now());
		//newTrip1.setTripCityZipCode();
		newTrip1.setTripLatitude(42.3600825);
		newTrip1.setTripLongitude(-71.05888010000001);
		newTrip1.setTripCity("Boston");
		newTrip1.setTripCountry("USA");
		newTrip1.setTripFormattedAddress("Boston, MA, USA");
		newTrip1.setTripName("My Boston Trip!");
		newTrip1.setUserId(1);
		
		Place place11 = new Place();
		Place place21 = new Place();
		Place place31 = new Place();
		place11.setDescription("Museum Description");
		place11.setLatitude("42.368316");
		place11.setLongitude("-71.072610");
		place11.setPlaceName("Museum of Science");
		place21.setDescription("Bar Description");
		place21.setLatitude("42.361106");
		place21.setLongitude("-71.063947");
		place21.setPlaceName("Tip Tap Room");
		place31.setDescription("Museum Description");
		place31.setLatitude("42.362373");
		place31.setLongitude("-71.097483");
		place31.setPlaceName("MIT Museum");
		List<Place> places2 = new ArrayList<Place>();
		places2.add(place11);
		places2.add(place21);
		places2.add(place31);
		newTrip1.setTripStops(places2);
		
		jdbcTripDao.saveNewTrip(newTrip1);

		
	}

}
