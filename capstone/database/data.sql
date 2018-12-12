-- *****************************************************************************
-- This script contains INSERT statements for populating tables with seed data
-- *****************************************************************************

BEGIN;

-- INSERT statements go here
INSERT INTO app_user (id, user_name, password, salt) VALUES (1, 'Nick','/rylmPI5R2mLI3UlneXmFA==','xGofVoq8k/ye/Elq/yC9yJ3L61hUonhKiYdhlZbHsI7YVNgN84eRsAMhY4kfdm+GOS8a2mi3qfzAD625+sORTpRWvLsPs13310j4XIEtMeT/hJMmNNa60NNMTJqi+ZMc1jTdrwkB6zX+w+SrKSs1a0JN1OgXRDBDvQVoRzhQM4A=');
INSERT INTO trip (user_id, trip_name, create_date, trip_city_zip_code, explore_radius) VALUES (1,'My First Trip', current_timestamp, 45040, 15);
INSERT INTO place (latitude, longitude, place_name, description) VALUES ('20.123123','31.12123','First Place','SOME TEXT');
INSERT INTO place (latitude, longitude, place_name, description) VALUES ('53.123123','27.12123','Second Place','SOME TEXT');
INSERT INTO place (latitude, longitude, place_name, description) VALUES ('-10.123123','100.12123','Third Place','SOME TEXT');
INSERT INTO trip_place (trip_id, place_id, stop_number) VALUES (1,1,1);
INSERT INTO trip_place (trip_id, place_id, stop_number) VALUES (1,2,2);
INSERT INTO trip_place (trip_id, place_id, stop_number) VALUES (1,3,3);



COMMIT;