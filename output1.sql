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

--Display all results where url equals below
select * from movies where url = 'the-hunger-games';

--Make adjustment to movies table to add one column
ALTER TABLE movies
ADD lexemesSummary tsvector;

--Populate lexemes information into newly created column
UPDATE movies
SET lexemesSummary = to_tsvector(Summary);

--Show all url's where previously created column contains pirate
SElECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('hunger');

--Make adjustment to movies table to add one column
ALTER TABLE movies
ADD rank float4;

--Populate ranking information into newly created column
UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='the-hunger-games'
)
));

--In case recommendation1 table exist it will be removed first
DROP TABLE if exists recommendation1;

--Create a new recommendation table
CREATE TABLE recommendation1 AS
SELECT url, Rank FROM  movies WHERE  rank >0.7 ORDER BY rank DESC limit 25;

--Write and save the recommendation table into a csv file
\copy (SELECT * FROM recommendation1) to '/home/pi/Desktop/RSL/recommendation1.csv' WITH csv;

--To view the recommended movies and their respective ranks in PostgreSQL
select * from recommendation1


--Show all url's where previously created column (lexemesSummary) contains fast
--SElECT url FROM movies
-- lexemesSummary @@ to_tsquery('fast');

--Make adjustment to movies table to add one column
--ALTER TABLE movies
--ADD rank_fast float4;

--Populate ranking information into newly created column
--UPDATE movies
--SET rank_fast = ts_rank(lexemesSummary,plainto_tsquery(
--(
--SELECT Summary FROM movies WHERE url='2-fast-2-furious'
--)
--));

--In case recommendationx table exist it will be removed first
--DROP TABLE if exists recommendationx;

--Create a new recommendation table
--CREATE TABLE recommendationx AS
--SELECT url, rank_fast FROM movies WHERE  rank_fast >0.01 ORDER BY rank_fast DESC limit 50;

--Write and save the recommendation table into a csv file
--\copy (SELECT * FROM recommendationx) to '/home/pi/Desktop/RSL/recommendationx.csv' WITH csv;



