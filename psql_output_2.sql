DROP TABLE if exists movies;

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

\copy movies FROM '/home/pi/Desktop/RSL/movies.csv' delimiter ';' csv header;

select * from movies where url = 'pirates-of-the-caribbean-the-curse-of-the-black-pearl';

ALTER TABLE movies
ADD lexemesSummary tsvector;

UPDATE movies
SET lexemesSummary = to_tsvector(Summary);

SElECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('pirate');

ALTER TABLE movies
ADD rank float4;

UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl'
)
));

DROP TABLE if exists recommendation1;
CREATE TABLE recommendation1 AS
SELECT url, Rank FROM  movies WHERE  rank >0.01 ORDER BY rank DESC limit 50;

\copy (SELECT * FROM recommendation1) to '/home/pi/Desktop/RSL/recommendation1.csv' WITH csv;



SElECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('fast');

ALTER TABLE movies
ADD rank_fast float4;

UPDATE movies
SET rank_fast = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='2-fast-2-furious'
)
));

DROP TABLE if exists recommendation2;
CREATE TABLE recommendation2 AS
SELECT url, rank_fast FROM movies WHERE  rank_fast >0.01 ORDER BY rank_fast DESC limit 50;

\copy (SELECT * FROM recommendation2) to '/home/pi/Desktop/RSL/recommendation2.csv' WITH csv;



ALTER TABLE movies
ADD lexTitle2 tsvector;

UPDATE movies
SET lexTitle2 = to_tsvector(Title);

SElECT url FROM movies
WHERE lexTitle2 @@ to_tsquery('kill');

ALTER TABLE movies
ADD rank_kill float4;

UPDATE movies
SET rank_kill = ts_rank(lextitle2,plainto_tsquery(
(
SELECT title FROM movies WHERE url='kill-list'
)
));

DROP TABLE if exists recommendation3;
CREATE TABLE recommendation3 AS
SELECT url, rank_kill FROM movies WHERE  rank_kill >0.01 ORDER BY rank_kill DESC limit 50;

\copy (SELECT * FROM recommendation3) to '/home/pi/Desktop/RSL/recommendation3.csv' WITH csv;



ALTER TABLE movies
ADD lexStar tsvector;

UPDATE movies
SET lexStar = to_tsvector(Starring);

SElECT url FROM movies
WHERE lexStar @@ to_tsquery('Jason');

ALTER TABLE movies
ADD rank_star float4;

UPDATE movies
SET rank_star = ts_rank(lexStar,plainto_tsquery(
(
SELECT starring FROM movies WHERE url='crank'
)
));

DROP TABLE if exists recommendation4;
CREATE TABLE recommendation4 AS
SELECT url, rank_star FROM movies WHERE  rank_star >0.01 ORDER BY rank_star DESC limit 50;

\copy (SELECT * FROM recommendation4) to '/home/pi/Desktop/RSL/recommendation4.csv' WITH csv;
