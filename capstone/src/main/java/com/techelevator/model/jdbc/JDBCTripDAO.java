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
		String saveNewTripSql = "INSERT INTO trip(id, user_id, trip_name, create_date, departure_date, trip_city_zip_code, trip_city, trip_country, trip_formatted_address, trip_latitude, trip_longitude, explore_radius) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);";
		jdbcTemplate.update(saveNewTripSql, trip.getTripId(), trip.getUserId(), trip.getTripName(), trip.getCreateDate(), trip.getDepartureDate(), trip.getTripCityZipCode(), trip.getTripCity(), trip.getTripCountry(), trip.getTripFormattedAddress(), trip.getTripLatitude(), trip.getTripLongitude(), trip.getExploreRadius());
		int stopNum = 1;
		for(int i = 0; i < trip.getTripStops().size(); i++) {
			Place place = trip.getTripStops().get(i);
			place.setPlaceId(getNextPlaceSeqId());
			String saveNewPlaceSql = "INSERT INTO place(id, latitude, longitude, place_name, description, place_json) VALUES (?,?,?,?,?,?);";
			jdbcTemplate.update(saveNewPlaceSql, place.getPlaceId(), place.getLatitude(), place.getLongitude(), place.getPlaceName(), place.getDescription(), place.getPlaceJson());
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
	
	@Override
	public Trip getTripByTripId(Integer tripId) {
		Trip trip = new Trip();
		String getTripByTripIdSql = "SELECT * FROM trip WHERE id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getTripByTripIdSql, tripId);
		while(results.next()) {
			trip = mapRowToTrip(results);
			trip.setTripStops(getAllPlacesForTrip(trip));
		}
		return trip;
	}
	
	//Used in the above getAllTripsForUser method and below in the updateSavedTrip method
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
	
	
	@Override
	public void updateSavedTrip(Trip updatedTrip) {
		String getOldTripSql = "SELECT * FROM trip WHERE id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getOldTripSql, updatedTrip.getTripId());
		Trip oldTrip = new Trip();
		while(results.next()) {
			oldTrip = mapRowToTrip(results);
		}
		oldTrip.setTripStops(getAllPlacesForTrip(oldTrip));
		String updateTripTableSql = "UPDATE trip SET trip_name = ?, last_edit_date = ?, departure_date = ?, trip_city_zip_code = ?, explore_radius = ?;";
		jdbcTemplate.update(updateTripTableSql, updatedTrip.getTripName(), updatedTrip.getLastEditDate(), updatedTrip.getDepartureDate(), updatedTrip.getTripCityZipCode(), updatedTrip.getExploreRadius());
		
		/*
		 * compare the two place lists, delete old ones not present in new one, insert new ones not present 
		 * in old one, update ones that are in both
		 */
		
		int[] oldPlaceIds = new int[] {oldTrip.getTripStops().size()};
		int[] newPlaceIds = new int[] {updatedTrip.getTripStops().size()};
		for(int i = 0; i < oldPlaceIds.length; i++) {
			oldPlaceIds[i] = oldTrip.getTripStops().get(i).getPlaceId();
		}
		for(int i = 0; i < newPlaceIds.length; i++) {
			newPlaceIds[i] = updatedTrip.getTripStops().get(i).getPlaceId();
		}
		
		List<Integer> deleteList = getPlacesToDeleteForUpdate(oldPlaceIds, newPlaceIds);
		List<Place> insertList = getPlacesToInsertForUpdate(updatedTrip);
		List<Integer> updateList = getPlacesToUpdateForUpdate(oldPlaceIds, newPlaceIds);
		
		String deleteTripPlaceSql = "DELETE FROM trip_place WHERE place_id = ?;";
		String deletePlaceSql = "DELETE FROM place WHERE id = ?;";
		if(deleteList.size() > 0) {
			for(int i = 0; i < deleteList.size(); i++) {
				jdbcTemplate.update(deleteTripPlaceSql, deleteList.get(i));
				jdbcTemplate.update(deletePlaceSql, deleteList.get(i));
			}
		}
		String insertPlaceSql = "INSERT INTO place(id, latitude, longitude, place_name, description) VALUES(?,?,?,?,?);";
		String insertTripPlaceSql = "INSERT INTO trip_place(trip_id, place_id) VALUES(?,?);";
		if(insertList.size() > 0) {
			for(int i = 0; i < insertList.size(); i++) {
				Place place = insertList.get(i);
				jdbcTemplate.update(insertPlaceSql, place.getPlaceId(), place.getLatitude(), place.getLongitude(), place.getPlaceName(), place.getDescription());
				jdbcTemplate.update(insertTripPlaceSql, updatedTrip.getTripId(), place.getPlaceId());
			}
		}
		
		if(updateList.size() > 0) {
			//NEED TO UPDATE STOPS, PROBABLY NOT REFERENCING UPDATELIST. NEED TO ADD IN UPDATED PLACES FROM INSERT PLACE INTO UPDATETRIP OBJECT SO I CAN ACCESS PLACE_ID.
		}
	}
	
	//Used in update method to find places no longer in a users Trip itinerary
	private List<Integer> getPlacesToDeleteForUpdate(int[] oldPlaceIds, int[] newPlaceIds) {
		List<Integer> deleteList = new ArrayList<Integer>();
		for(int i = 0; i < oldPlaceIds.length; i++) {
			boolean found = false;
			for(int j = 0; j < newPlaceIds.length; j++) {
				if(oldPlaceIds[i] == newPlaceIds[j]) {
					found = true;
				}
			}
			if(!found) {
				deleteList.add(oldPlaceIds[i]);
			}
		}
		return deleteList;
	}
	
	//Used in update method to find new places to insert from a users Trip itinerary
	private List<Place> getPlacesToInsertForUpdate(Trip updatedTrip) {
		List<Place> insertList = new ArrayList<Place>();
		for(int i = 0; i < updatedTrip.getTripStops().size(); i++) {
			Place place = updatedTrip.getTripStops().get(i);
			if(place.getPlaceId() == 0) {
				place.setPlaceId(getNextPlaceSeqId());
				insertList.add(place);
			}
		}
		return insertList;
	}
	
	//Used in update method to find places in both a users old and new Trip itinerary, to then update
	private List<Integer> getPlacesToUpdateForUpdate(int[] oldPlaceIds, int[] newPlaceIds) {
		List<Integer> updateList = new ArrayList<Integer>();
		for(int i = 0; i < oldPlaceIds.length; i++) {
			boolean found = false;
			for(int j = 0; j < newPlaceIds.length; j++) {
				if(oldPlaceIds[i] == newPlaceIds[j]) {
					found = true;
				}
			}
			if(found) {
				updateList.add(oldPlaceIds[i]);
			}
		}
		return updateList;
	}
	
	/**
	 * Deletes all data associated with a given tripId. First, it gets a list of placeId's linked to a given tripId.
	 * Next it deletes all data from the trip_place table associated with the given tripId. Then it deletes all data
	 * from the place table for the given tripId. Then it deletes all places that were gathered from the first search
	 * query.
	 * @param tripId
	 */
	@Override
	public void deleteSavedTrip(Integer tripId) {
		List<Integer> placeIdList = new ArrayList<Integer>();
		String getPlacesForTripSql = "SELECT p.id FROM place p JOIN trip_place tp ON (p.id = tp.place_id) WHERE tp.trip_id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(getPlacesForTripSql, tripId);
		while(results.next()) {
			placeIdList.add(results.getInt("id"));
		}
		String deleteFromTripPlaceSql = "DELETE FROM trip_place WHERE trip_id = ?;";
		jdbcTemplate.update(deleteFromTripPlaceSql, tripId);
		String deleteFromPlaceSql = "DELETE FROM place WHERE id = ?;";
		for(int i = 0; i < placeIdList.size(); i++) {
			jdbcTemplate.update(deleteFromPlaceSql, placeIdList.get(i));
		}
		String deleteTripFromTripSql = "DELETE FROM trip WHERE id = ?;";
		jdbcTemplate.update(deleteTripFromTripSql, tripId);
	}
	
	
	/*
	 * THESE ARE ALL PRIVATE METHODS BELOW UTILIZED IN THE ABOVE METHODS
	 */
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
		Trip trip = new Trip(new java.sql.Timestamp(results.getDate("create_date").getTime()).toLocalDateTime(), new java.sql.Timestamp(results.getDate("departure_date").getTime()).toLocalDateTime());
		trip.setExploreRadius(results.getInt("explore_radius"));
		trip.setTripId(results.getInt("id"));
		trip.setTripName(results.getString("trip_name"));
		trip.setUserId(results.getInt("user_id"));
		trip.setTripCityZipCode(results.getInt("trip_city_zip_code"));
		trip.setTripCity(results.getString("trip_city"));
		trip.setTripCountry(results.getString("trip_country"));
		trip.setTripFormattedAddress(results.getString("trip_formatted_address"));
		trip.setTripLatitude(results.getDouble("trip_latitude"));
		trip.setTripLongitude(results.getDouble("trip_longitude"));
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
		place.setPlaceJson(results.getString("place_json"));
		return place;
	}
}
