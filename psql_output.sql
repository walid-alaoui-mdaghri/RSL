CREATE TABLE nf ( url text, 
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

\copy nf FROM '/home/pi/Desktop/RSL/movies.csv' delimiter ';' csv header;

select * from nf where url = 'pirates-of-the-caribbean-the-curse-of-the-black-pearl';

ALTER TABLE nf
ADD lexemesSummary tsvector;

UPDATE nf
SET lexemesSummary = to_tsvector(Summary);

SElECT url FROM nf
WHERE lexemesSummary @@ to_tsquery('pirate');

ALTER TABLE nf
ADD rank float4;

UPDATE nf
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM nf WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl'
)
));

CREATE TABLE recomA AS
SELECT url, Rank FROM  nf WHERE  rank >0.01 ORDER BY rank DESC limit 50;

\copy (SELECT * FROM recomA) to '/home/pi/Desktop/RSL/recomA.csv' WITH csv;

##############

SElECT url FROM nf
WHERE lexemesSummary @@ to_tsquery('fast');

ALTER TABLE nf
ADD rank_fast float4;

UPDATE nf
SET rank_fast = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM nf WHERE url='2-fast-2-furious'
)
));

CREATE TABLE recomB AS
SELECT url, rank_fast FROM nf WHERE  rank_fast >0.01 ORDER BY rank_fast DESC limit 50;

\copy (SELECT * FROM recomB) to '/home/pi/Desktop/RSL/recomB.csv' WITH csv;

###############

ALTER TABLE nf
ADD lexTitle2 tsvector;

UPDATE nf
SET lexTitle2 = to_tsvector(Title);

SElECT url FROM nf
WHERE lexTitle2 @@ to_tsquery('kill');

ALTER TABLE nf
ADD rank_kill float4;

UPDATE nf
SET rank_kill = ts_rank(lextitle2,plainto_tsquery(
(
SELECT title FROM nf WHERE url='kill-list'
)
));

CREATE TABLE recomC AS
SELECT url, rank_kill FROM nf WHERE  rank_kill >0.01 ORDER BY rank_kill DESC limit 50;

\copy (SELECT * FROM recomC) to '/home/pi/Desktop/RSL/recomC.csv' WITH csv;

##########

ALTER TABLE nf
ADD lexStar tsvector;

UPDATE nf
SET lexStar = to_tsvector(Starring);

SElECT url FROM nf
WHERE lexStar @@ to_tsquery('Jason');

ALTER TABLE nf
ADD rank_star float4;

UPDATE nf
SET rank_star = ts_rank(lexStar,plainto_tsquery(
(
SELECT starring FROM nf WHERE url='crank'
)
));

CREATE TABLE recomD AS
SELECT url, rank_star FROM nf WHERE  rank_star >0.01 ORDER BY rank_star DESC limit 50;

\copy (SELECT * FROM recomD) to '/home/pi/Desktop/RSL/recomD.csv' WITH csv;
