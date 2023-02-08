CREATE TABLE IF NOT EXISTS TopStreamedSongs (ranking INT, artistname STRING, songname STRING,
peakinrank INT, reproductions INT)
COMMENT 'Top stream songs'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/mnt/c/Users/hadoop/stream';

CREATE TABLE IF NOT EXISTS TopByYear (artistname STRING, songname STRING, genre STRING, yearofrelease INT)
COMMENT 'Top by year'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/mnt/c/Users/hadoop/top';

CREATE TABLE IF NOT EXISTS TopByYear (artistname STRING, songname STRING, genre STRING)
COMMENT 'Song by REST API'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/mnt/c/Users/hadoop/top';

----------------------------------------------------------------------------------------------------------

SELECT * FROM TopStreamedSongs WHERE reproductions > 100000 AND peakinrank < 10;

SELECT * FROM TopByYear WHERE yearofrelease = 2019 AND genre = 'Pop';

----------------------------------------------------------------------------------------------------------

SELECT * FROM TopStreamedSongs JOIN reproductions ON (TopStreamedSongs.songname = TopByYear.songname)