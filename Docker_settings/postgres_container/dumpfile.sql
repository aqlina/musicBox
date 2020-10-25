-- PostgreSQL DB dump file
-- 19.10.2020

--SET statement_timeout = 0;
--SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
--SET client_encoding = 'UTF8';
--SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
--SET check_function_bodies = false;
--SET xmloption = content;
--SET client_min_messages = warning;
--SET row_security = off;

-- create db

CREATE DATABASE "musicianbox-db"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

\connect "musicianbox-db"

CREATE SCHEMA musicianbox;

SET search_path TO musicianbox;

CREATE TABLE musicians (

	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	surname VARCHAR(50) NOT NULL
);

CREATE TABLE bands (

	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE events (

	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	musician_id INT,
	band_id INT,
	CONSTRAINT ev
	   FOREIGN KEY(musician_id)
	       REFERENCES musicians(id),
	CONSTRAINT ev2
	   FOREIGN KEY(band_id)
	       REFERENCES bands(id)
);

-- fill db table with the content

INSERT INTO musicians (id, name, surname)
	VALUES (1, 'John', 'Lenon'),
	       (2, 'Paul', 'McCartney'),
	       (3, 'George', 'Harrison'),
	       (4, 'Ringo', 'Starr'),
	       (5, 'Charlie', 'Watts'),
	       (6, 'Mick', 'Jagger'),
	       (7, 'Keith', 'Richards'),
	       (8, 'Syd', 'Barett'),
	       (9, 'Anthony', 'Kiedis'),
	       (10, 'Chad', 'Smith'),
               (11, 'Alex', 'Turner'),
	       (12, 'Jamie', 'Cook'),
	       (13, 'Matt', 'Helders'),
	       (14, 'Billy', 'Corgan'),
	       (15, 'Jimmy', 'Chamberlin'),
	       (16, 'Jeff', 'Schroeder'),
	       (17, 'Kurt', 'Cobain'),
	       (18, 'Dave', 'Grohl'),
	       (19, 'Krist', 'Novoselic'),
	       (20, 'Bon', 'Scott'),
	       (21, 'Mark', 'Evans');

INSERT INTO bands (id, name)
	VALUES (1, 'The Beatles'),
	       (2, 'Pink Floyd'),
	       (3, 'Led Zeppelin'),
	       (4, 'AC/DC'),
	       (5, 'Black Sabbath'),
	       (6, 'Red Hot Chili Peppers'),
	       (7, 'The Police'),
	       (8, 'Big Star'),
	       (9, 'Nirvana'),
	       (10, 'Blondie'),
	       (11, 'The Rolling Stong');

INSERT INTO events (id, name, musician_id, band_id)
	VALUES (1, 'Beatnik Summer Festival', 1, 1),
	       (2, 'Beatnik Summer Festival', 1, 2),
	       (3, 'Beatnik Summer Festival', 2, 1),
	       (4, 'Beatnik Summer Festival', 3, 1),
	       (5, 'Beatnik Summer Festival', 4, 2),
	       (6, 'FestiVista', 21, 7),
	       (7, 'FestiVista', 12, 5),
	       (8, 'FestiVista', 11, 5),
	       (9, 'FestiVista', 21, 5),
	       (10, 'FestiVista', 5, 7),
	       (11, 'Night Pulse', 21, 6),
	       (12, 'Night Pulse', 18, 4),
	       (13, 'Night Pulse', 19, 4),
	       (14, 'Night Pulse', 17, 6),
	       (15, 'Sound Spirit Fest', 10, 10),
	       (16, 'Chill Vibez Music', 6, 9),
	       (17, 'Chill Vibez Music', 7, 9),
	       (18, 'Chill Vibez Music', 8, 3),
	       (19, 'Chill Vibez Music', 9, 4),
	       (20, 'Chill Vibez Music', 12, 3),
	       (21, 'Chill Vibez Music', 13, 4),
	       (22, 'Chill Vibez Music', 14, 11),
	       (23, 'Chill Vibez Music', 15, 11);

CREATE VIEW prepared_events AS
SELECT events.name AS event_name, 
musicians.id AS musician_id, 
musicians.name AS musician_name, 
musicians.surname AS musician_surname, 
bands.name AS band
FROM events
JOIN musicians
ON musicians.id = events.musician_id
JOIN bands
ON bands.id = events.band_id;





