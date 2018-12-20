-- *************************************************************************************************
-- This script creates all of the database objects (tables, sequences, etc) for the database
-- *************************************************************************************************

BEGIN;

-- CREATE statements go here
DROP TABLE IF EXISTS trip_place;
DROP TABLE IF EXISTS trip;
DROP TABLE IF EXISTS app_user;
DROP TABLE IF EXISTS place;


CREATE TABLE app_user (
  id SERIAL,
  user_name varchar(32) NOT NULL UNIQUE,
  password varchar(32) NOT NULL,
  role varchar(32),
  salt varchar(255) NOT NULL,
  CONSTRAINT pk_app_user_id PRIMARY KEY (id)
);

CREATE TABLE trip (
  id SERIAL,
  user_id integer NOT NULL,
  trip_name varchar(100),
  create_date timestamptz,
  last_edit_date timestamptz,
  departure_date timestamptz,
  trip_city_zip_code integer,
  trip_city varchar,
  trip_state varchar,
  trip_country varchar,
  trip_formatted_address varchar,
  trip_latitude numeric,
  trip_longitude numeric,
  trip_json varchar,
  explore_radius integer CHECK (explore_radius >= 1 AND explore_radius <= 999),
  CONSTRAINT pk_trip_id PRIMARY KEY (id),
  CONSTRAINT fk_trip_user_id FOREIGN KEY (user_id) REFERENCES app_user(id)
);

CREATE TABLE place (
  id SERIAL,
  latitude varchar(24),
  longitude varchar(24),
  place_name text,
  place_json varchar,
  description text,
  CONSTRAINT pk_place_id PRIMARY KEY (id)
);

CREATE TABLE trip_place (
  trip_id integer NOT NULL,
  place_id integer NOT NULL,
  stop_number integer,
  CONSTRAINT pk_trip_place_trip_id_place_id PRIMARY KEY (trip_id, place_id),
  CONSTRAINT fk_trip_place_trip_id FOREIGN KEY (trip_id) REFERENCES trip(id),
  CONSTRAINT fk_trip_place_place_id FOREIGN KEY (place_id) REFERENCES place(id)
);

COMMIT;