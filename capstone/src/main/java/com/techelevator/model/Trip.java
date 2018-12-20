package com.techelevator.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Trip {
	
	private int tripId;
	private int userId;
	private String tripName;
	private LocalDateTime createDate;
	private LocalDateTime lastEditDate;
	private LocalDateTime departureDate;
	private String createDateString;
	private String lastEditDateString;
	private String departureDateString;
	private int tripCityZipCode;
	private double tripLatitude;
	private double tripLongitude;
	private String tripFormattedAddress;
	private String tripCity;
	private String tripState;
	private String tripCountry;
	private String tripJson;
	private int exploreRadius;
	private List<Place> tripStops;
	
	public Trip() {
		this.tripStops = new ArrayList<Place>();
	}
	
	public Trip(LocalDateTime createDate, LocalDateTime departureDate) {
		this.tripStops = new ArrayList<Place>();
		this.createDate = createDate;
		this.departureDate = departureDate;
		setCreateDateString(this.createDate);
		setDepartureDateString(this.departureDate);
	}
	
	public int getTripId() {
		return tripId;
	}
	public void setTripId(int tripId) {
		this.tripId = tripId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getTripName() {
		return tripName;
	}
	public void setTripName(String tripName) {
		this.tripName = tripName;
	}
	public LocalDateTime getCreateDate() {
		return createDate;
	}
	public void setCreateDate(LocalDateTime createDate) {
		this.createDate = createDate;
	}
	public LocalDateTime getLastEditDate() {
		return lastEditDate;
	}
	public void setLastEditDate(LocalDateTime lastEditDate) {
		this.lastEditDate = lastEditDate;
	}
	public LocalDateTime getDepartureDate() {
		return departureDate;
	}
	public void setDepartureDate(LocalDateTime departureDate) {
		this.departureDate = departureDate;
	}
	public String getCreateDateString() {
		return createDateString;
	}
	private void setCreateDateString(LocalDateTime createDate) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		this.createDateString = createDate.format(formatter);
	}
	public String getLastEditDateString() {
		return lastEditDateString;
	}
	public void setLastEditDateString(String lastEditDateString) {
		this.lastEditDateString = lastEditDateString;
	}
	public String getDepartureDateString() {
		return departureDateString;
	}
	private void setDepartureDateString(LocalDateTime departureDate) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("E, MMM dd, yyyy");
		this.departureDateString = departureDate.format(formatter);
	}
	public int getTripCityZipCode() {
		return tripCityZipCode;
	}
	public void setTripCityZipCode(int tripCityZipCode) {
		this.tripCityZipCode = tripCityZipCode;
	}
	public double getTripLatitude() {
		return tripLatitude;
	}
	public void setTripLatitude(double tripLatitude) {
		this.tripLatitude = tripLatitude;
	}
	public double getTripLongitude() {
		return tripLongitude;
	}
	public void setTripLongitude(double tripLongitude) {
		this.tripLongitude = tripLongitude;
	}
	public String getTripFormattedAddress() {
		return tripFormattedAddress;
	}
	public void setTripFormattedAddress(String tripFormattedAddress) {
		this.tripFormattedAddress = tripFormattedAddress;
	}
	public String getTripCity() {
		return tripCity;
	}
	public void setTripCity(String tripCity) {
		this.tripCity = tripCity;
	}
	public String getTripState() {
		return tripState;
	}
	public void setTripState(String tripState) {
		this.tripState = tripState;
	}
	public String getTripCountry() {
		return tripCountry;
	}
	public void setTripCountry(String tripCountry) {
		this.tripCountry = tripCountry;
	}
	public String getTripJson() {
		return tripJson;
	}

	public void setTripJson(String tripJson) {
		this.tripJson = tripJson;
	}

	public int getExploreRadius() {
		return exploreRadius;
	}
	public void setExploreRadius(int exploreRadius) {
		this.exploreRadius = exploreRadius;
	}
	public List<Place> getTripStops() {
		return tripStops;
	}
	public void setTripStops(List<Place> tripStops) {
		this.tripStops = tripStops;
	}
	public void addStopToTripStops(Place place) {
		this.tripStops.add(place);
	}
	public void clearAllStops() {
		this.tripStops.clear();;
	}
}
