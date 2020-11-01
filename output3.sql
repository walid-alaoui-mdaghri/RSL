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
ADD lexStar tsvector;

--Populate lexemes information into newly created column
UPDATE movies
SET lexStar = to_tsvector(Starring);

--Show all url's where previously created column contains Jason
SElECT url FROM movies
WHERE lexStar @@ to_tsquery('Lawrence');

--Make adjustment to movies table to add one column
ALTER TABLE movies
ADD rank_star float4;

--Populate ranking information into newly created column
UPDATE movies
SET rank_star = ts_rank(lexStar,plainto_tsquery(
(
SELECT starring FROM movies WHERE url='the-hunger-games'
)
));

--In case recommendation3 table exist it will be removed first
DROP TABLE if exists recommendation3;

--Create a new recommendation table
CREATE TABLE recommendation3 AS
SELECT url, rank_star FROM movies WHERE  rank_star >0.7 ORDER BY rank_star DESC limit 25;

--Write and save the recommendation table into a csv file
\copy (SELECT * FROM recommendation3) to '/home/pi/Desktop/RSL/recommendation3.csv' WITH csv;

--To view the recommended movies and their respective ranks in PostgreSQL
select * from recommendation3
