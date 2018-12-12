package com.techelevator.model.jdbc;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Place;
import com.techelevator.model.Trip;
import com.techelevator.model.TripDAO;

@Component
public class JDBCTripDAO implements TripDAO {
	
	private JdbcTemplate jdbcTemplate; 
	
	@Autowired
	public JDBCTripDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	/**
	 * Saves a new Trip object into the database. After inserting the Trip properties into the database it also
	 * inserts the properties of each Place contained inside the Trip's tripStops list. It then inserts the tripId
	 * and placeId into the trip_place relational table and assigns a stop number based on each place's order in the
	 * tripStops list.
	 * @param trip
	 */
	@Override
	public void saveNewTrip(Trip trip) {
		trip.setTripId(getNextTripSeqId());
		String saveNewTripSql = "INSERT INTO trip(id, user_id, trip_name, create_date, departure_date, trip_city_zip_code, explore_radius) VALUES (?,?,?,?,?,?,?);";
		jdbcTemplate.update(saveNewTripSql, trip.getTripId(), trip.getUserId(), trip.getTripName(), trip.getCreateDate(), trip.getDepartureDate(), trip.getTripCityZipCode(), trip.getExploreRadius());
		int stopNum = 1;
		for(int i = 0; i < trip.getTripStops().size(); i++) {
			Place place = trip.getTripStops().get(i);
			place.setPlaceId(getNextPlaceSeqId());
			String saveNewPlaceSql = "INSERT INTO place(id, latitude, longitude, place_name, description) VALUES (?,?,?,?,?);";
			jdbcTemplate.update(saveNewPlaceSql, place.getPlaceId(), place.getLatitude(), place.getLongitude(), place.getPlaceName(), place.getDescription());
			String saveTripPlaceRelationSql = "INSERT INTO trip_place(trip_id, place_id, stop_number) VALUES (?,?,?);";
			jdbcTemplate.update(saveTripPlaceRelationSql, trip.getTripId(), place.getPlaceId(), stopNum);
			stopNum++;
		}
	}
	
	/**
	 * Gets a list of Trip objects given a user id. During the addition of each trip to our allTrips list, we run
	 * another private method, getAllPlacesForTrip, that retrieves all the places for that trip and assigns the results to
	 * the newly created trip object before being added to the list.
	 * @param userId
	 * @return
	 */
	@Override
	public List<Trip> getAllTripsForUser(Integer userId) {
		List<Trip> allTrips = new ArrayList<Trip>();
		String getAllTripsForUserSql = "SELECT * FROM trip WHERE user_id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getAllTripsForUserSql, userId);
		while(results.next()) {
			Trip trip = mapRowToTrip(results);
			trip.setTripStops(getAllPlacesForTrip(trip));
			allTrips.add(trip);
		}
		return allTrips;
	}
	
	private List<Place> getAllPlacesForTrip(Trip trip) {
		List<Place> allStopsForTrip = new ArrayList<Place>();
		String getAllPlacesForTripSql = "SELECT p.id, p.latitude, p.longitude, p.place_name, p.description, tp.stop_number FROM place p JOIN trip_place tp ON (p.id = tp.place_id) WHERE tp.trip_id = ? ORDER BY stop_number;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getAllPlacesForTripSql, trip.getTripId());
		while(results.next()) {
			Place place = mapRowToPlace(results);
			allStopsForTrip.add(place);
		}
		return allStopsForTrip;
	}
	
	private Integer getNextTripSeqId() {
		String getNextTripSeqSql = "Select NEXTVAL(pg_get_serial_sequence('trip', 'id'));";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getNextTripSeqSql);
		Integer nextId = null;
		while(results.next()) {
			nextId = results.getInt("nextval");
		}
		return nextId;
	}
	
	private Trip mapRowToTrip(SqlRowSet results) {
		Trip trip = new Trip();
		trip.setCreateDate(new java.sql.Timestamp(results.getDate("create_date").getTime()).toLocalDateTime());
		trip.setExploreRadius(results.getInt("explore_radius"));
		trip.setTripId(results.getInt("id"));
		trip.setTripName(results.getString("trip_name"));
		trip.setUserId(results.getInt("user_id"));
		if(results.getString("departure_date") != null) {
			trip.setDepartureDate(new java.sql.Timestamp(results.getDate("departure_date").getTime()).toLocalDateTime());
		}
		if(results.getString("last_edit_date") != null) {
			trip.setLastEditDate(new java.sql.Timestamp(results.getDate("last_edit_date").getTime()).toLocalDateTime());
		}
		return trip;
	}
	
	private Integer getNextPlaceSeqId() {
		String getNextTripSeqSql = "Select NEXTVAL(pg_get_serial_sequence('place', 'id'));";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getNextTripSeqSql);
		Integer nextId = null;
		while(results.next()) {
			nextId = results.getInt("nextval");
		}
		return nextId;
	}
	
	private Place mapRowToPlace(SqlRowSet results) {
		Place place = new Place();
		place.setDescription(results.getString("description"));
		place.setLatitude(results.getString("latitude"));
		place.setLongitude(results.getString("longitude"));
		place.setPlaceId(results.getInt("id"));
		place.setPlaceName(results.getString("place_name"));
		return place;
	}
}
