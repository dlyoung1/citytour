package com.techelevator.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Trip {
	
	private int tripId;
	private int userId;
	private String tripName;
	private LocalDateTime createDate;
	private LocalDateTime lastEditDate;
	private LocalDateTime departureDate;
	private int tripCityZipCode;
	private String tripFormattedAddress;
	private String tripCity;
	private String tripState;
	private String tripCountry;
	private int exploreRadius;
	private List<Place> tripStops;
	
	public Trip() {
		this.tripStops = new ArrayList<Place>();
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
	public int getTripCityZipCode() {
		return tripCityZipCode;
	}
	public void setTripCityZipCode(int tripCityZipCode) {
		this.tripCityZipCode = tripCityZipCode;
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
