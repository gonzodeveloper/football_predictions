/*
* Kyle Hart
* 4 Sept 2017
*
* Project: beastcode
* File: populate_tables.sql
* Description: inserts data from the RAW tables into the league tables
*               DOES NOT INCLUDE weather data and tables
*/

DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS preformance;


CREATE TABLE team (
    team_id INT NOT NULL,
    team_name VARCHAR(50) NOT NULL,
    station_id VARCHAR(20) NOT NULL,
	CONSTRAINT pk_team PRIMARY KEY (team_id)
);

/* 
* insert the following line into my.cnf file, otherwise this wont work
* sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
*/

INSERT INTO team (team_id, team_name, station_id)
	    SELECT rw_skool.team_id,
			rw_schl.team_name,
            rw_skool.station_id
		FROM raw_schools AS rw_skool
        JOIN (SELECT * FROM raw_schedule GROUP BY team_id ) AS rw_schl ON 1=1
            AND rw_skool.team_id = rw_schl.team_id;

CREATE TABLE game(
    game_id INT NOT NULL AUTO_INCREMENT,
    team_1_id INT NOT NULL,
    team_2_id INT NOT NULL,
    game_date DATE NOT NULL,
    location VARCHAR(20),
    CONSTRAINT pk_game PRIMARY KEY (game_id)
);

CREATE INDEX idx_gamedate ON game (game_date);

INSERT INTO game( team_1_id, team_2_id, game_date, location )
    SELECT
        raw.team_id,
        raw.opp_id,
        STR_TO_DATE(raw.game_date, '%m/%d/%y'),
        raw.location
    FROM raw_schedule as raw;


CREATE TABLE player(
    player_id INT NOT NULL AUTO_INCREMENT,
    lname VARCHAR(25) NOT NULL,
    fname VARCHAR(25),
    team_id INT NOT NULL,
    CONSTRAINT pk_player PRIMARY KEY(player_id),
    CONSTRAINT fk_player_team FOREIGN KEY (team_id)
        REFERENCES team(team_id)
);

INSERT INTO player (lname, fname, team_id)
    SELECT DISTINCT
        raw.lname,
        raw.fname,
        raw.team_id
    FROM raw_offense as raw
    GROUP BY raw.lname, raw.fname, raw.uniform_num;

CREATE TABLE preformance(
    player_id INT NOT NULL,
    game_id INT NOT NULL,
    rush_net INT,
    rush_td INT,
    pass_yards INT,
    pass_td INT,
    ttl_yards INT,
    ttl_td INT,
    CONSTRAINT fk_preformance_player FOREIGN KEY (player_id)
        REFERENCES player(player_id),
    CONSTRAINT fk_preformance_game FOREIGN KEY (game_id)
        REFERENCES game(game_id)
);

CREATE INDEX idx_gameid ON preformance (game_id);


INSERT INTO preformance(player_id, game_id, rush_net, rush_td, pass_yards, pass_td, ttl_yards, ttl_td)
   SELECT DISTINCT
       player.player_id,
       game.game_id,
       raw.rush_net,
       raw.rush_td,
       raw.pass_yards,
       raw.pass_td,
       raw.ttl_yards,
       raw.ttl_td
   FROM player
   JOIN team ON 1=1
        AND player.team_id = team.team_id
   JOIN game ON 1=1
        AND team.team_id = game.team_1_id
   JOIN raw_offense raw ON 1=1
   WHERE 1=1
       AND game.game_date = STR_TO_DATE(raw.game_date, '%m/%d/%y')
       AND	player.lname = raw.lname
       AND player.fname = raw.fname
       AND team.team_id = raw.team_id;

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE game
   ADD CONSTRAINT fk_game_t1
       FOREIGN KEY(team_1_id)
       REFERENCES team(team_id)
       ON UPDATE CASCADE;

ALTER TABLE game
   ADD CONSTRAINT fk_game_t2
       FOREIGN KEY(team_2_id)
       REFERENCES team(team_id)
       ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS=1;
