--In case movies table exist it will be removed first
DROP TABLE if exists movies;

--Create a new table within database with 12 different columns
CREATE TABLE movies ( url text, 
	title text, 
	ReleaseDate text, 
	Distributor text, 
	Starring text, 
	Summary text,
	Director text, 
	Genre text, 
	Rating text, 
	Runtime text, 
	Userscore text, 
	Metascore text, 
	scoreCounts text);
	
--Load data records from csv file into newly created movies table
\copy movies FROM '/home/pi/Desktop/RSL/movies.csv' delimiter ';' csv header;

--Make adjustment to movies table to add one column
ALTER TABLE movies
ADD lexTitle2 tsvector;

--Populate lexemes information into newly created column
UPDATE movies
SET lexTitle2 = to_tsvector(Title);

--Show all url's where previously created column contains kill
SElECT url FROM movies
WHERE lexTitle2 @@ to_tsquery('hunger');

--Make adjustment to movies table to add one column
ALTER TABLE movies
ADD rank_title float4;

--Populate ranking information into newly created column
UPDATE movies
SET rank_title = ts_rank(lextitle2,plainto_tsquery(
(
SELECT title FROM movies WHERE url='the-hunger-games'
)
));

--In case recommendation2 table exist it will be removed first
DROP TABLE if exists recommendation2;

--Create a new recommendation table
CREATE TABLE recommendation2 AS
SELECT url, rank_title FROM movies WHERE  rank_title >0.7 ORDER BY rank_title DESC limit 25;

--Write and save the recommendation table into a csv file
\copy (SELECT * FROM recommendation2) to '/home/pi/Desktop/RSL/recommendation2.csv' WITH csv;

--To view the recommended movies and their respective ranks in PostgreSQL
select * from recommendation2

