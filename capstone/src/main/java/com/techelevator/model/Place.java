package com.techelevator.model;

public class Place {
	
	private int placeId;
	private String latitude;
	private String longitude;
	private String placeName;
	private String description;
	private String placeJson;
	
	public Place() {
		this.placeId = 0;
	}
	public int getPlaceId() {
		return placeId;
	}
	public void setPlaceId(int placeId) {
		this.placeId = placeId;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getPlaceName() {
		return placeName;
	}
	public void setPlaceName(String placeName) {
		this.placeName = placeName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getPlaceJson() {
		return placeJson;
	}
	public void setPlaceJson(String placeJson) {
		this.placeJson = placeJson;
	}
	
}
