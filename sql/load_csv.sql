/*
* Kyle Hart 
* 4 Sept 2017
* 
* Project: football_predictions
* File: load_csv.sql
* Description: loads data from RAW csv files into raw tables in the league database
* 
*/

USE league;


/* 2008 data */
LOAD DATA LOCAL INFILE 'raw/defense_2008.csv'
            INTO TABLE raw_defense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/offense_2008.csv'
            INTO TABLE raw_offense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'raw/schedule_2008.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

/* 2009 data */
LOAD DATA LOCAL INFILE 'raw/defense_2009.csv'
            INTO TABLE raw_defense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/offense_2009.csv'
            INTO TABLE raw_offense
            FIELDS TERMINATED BY ',' 
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schedule_2009.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;
/* 2010 data */
LOAD DATA LOCAL INFILE 'raw/defense_2010.csv'
            INTO TABLE raw_defense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/offense_2010.csv'
            INTO TABLE raw_offense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schedule_2010.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

/* 2011 data */
LOAD DATA LOCAL INFILE 'raw/defense_2011.csv'
            INTO TABLE raw_defense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/offense_2011.csv'
            INTO TABLE raw_offense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schedule_2011.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

/* 2012 data */
LOAD DATA LOCAL INFILE 'raw/defense_2012.csv'
            INTO TABLE raw_defense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/offense_2012.csv'
            INTO TABLE raw_offense
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schedule_2012.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schedule_2012.csv'
            INTO TABLE raw_schedule
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

LOAD DATA LOCAL INFILE 'raw/schools.csv'
	INTO TABLE raw_schools
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            ESCAPED BY '"'
            LINES TERMINATED BY '\n' ;

/* Had to add these because the IGNORE LINES option was screwing with the load cmd */

DELETE FROM raw_offense
	WHERE team_id = 0;
DELETE FROM raw_defense
	WHERE team_id = 0;
DELETE FROM raw_schedule
	WHERE team_id = 0;
DELETE FROM raw_schools
	WHERE team_id = 0;
