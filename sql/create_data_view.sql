/*
* Kyle Hart
* 5 Sept 2017
* 
* Project: football_predictions
* File: create_data_view.sql
* Description: Aggregates and reshapes the data from our existing tables into a "game_data_ table.
*	Each column in this table will be a feature vector for our KNN prediction model.
*
*/

/*
* Create a view showing us the aggregate of each team's rushing and passing yards for a given game 
*/
DROP VIEW IF EXISTS game_stats;
CREATE VIEW game_stats AS
SELECT
	team.team_id,
	game.game_id,
	game.game_date,
	game.team_2_id AS opp_id,
	SUM(preformance.rush_net) rush,
	SUM(preformance.pass_yards) pass
FROM preformance
INNER JOIN player ON 1=1
	AND preformance.player_id = player.player_id
INNER JOIN team ON 1=1
	AND player.team_id = team.team_id
INNER JOIN game ON 1=1
	AND team.team_id = game.team_1_id
	AND preformance.game_id = game.game_id
GROUP BY team.team_id, game.game_date;
/*
* Create a view showing the aggregate pass and rush stats for both the teams and their opponent for a given game
*/
DROP VIEW IF EXISTS full_game_stats;
CREATE VIEW full_game_stats AS
SELECT
	t1.game_id,
	t1.game_date,
	t1.team_id AS t1_id,
 	t1.rush AS t1_rush,
  	t1.pass AS t1_pass,
    	t2.team_id AS t2_id,
    	t2.rush AS t2_rush,
    	t2.pass AS t2_pass
FROM game_stats t1
INNER JOIN game_stats t2 ON 1=1
	AND t1.opp_id = t2.team_id
    	AND t1.game_date = t2.game_date;

/*
* Create function determine rush strength for a team on a given data.
* Strength is determined by the average of the team's net rushing over the last 10 games
*/
DELIMITER //
DROP FUNCTION IF EXISTS RUSH_STREN //
CREATE FUNCTION RUSH_STREN(
	date_param date,
    	team_id_param INT
)
	RETURNS INT
	BEGIN
        DECLARE rush_stren INT;
    	SELECT
		AVG(recent.rush) INTO rush_stren
	FROM
		(SELECT
			full_game_stats.t1_rush rush
	 	FROM full_game_stats
         	WHERE 1=1
			AND full_game_stats.t1_id = team_id_param
         		AND full_game_stats.game_date < date_param
		ORDER BY full_game_stats.game_date DESC
		LIMIT 10) recent;
        RETURN rush_stren;
	END //
DELIMITER ;
/*
* Create function determine pass strength for a team on a given data.
* Strength is determined by the average of the team's net passing over the last 10 games
*/

DELIMITER //
DROP FUNCTION IF EXISTS PASS_STREN //
CREATE FUNCTION PASS_STREN(
	date_param date,
	team_id_param INT
)
	RETURNS INT
	BEGIN
        DECLARE pass_stren INT;
	SELECT
		AVG(recent.pass) INTO pass_stren
	FROM
		(SELECT
			full_game_stats.t1_pass pass
		FROM full_game_stats
        	WHERE 1=1
			AND full_game_stats.t1_id = team_id_param
                	AND full_game_stats.game_date < date_param
		ORDER BY full_game_stats.game_date DESC
		LIMIT 10) recent;
        RETURN pass_stren;
	END //
DELIMITER ;
/*
* Create function determine rush weakness for a team on a given data.
* Weakness is determined by the average of the team's opponents' net rushing over the last 10 games
*/

DELIMITER //
DROP FUNCTION IF EXISTS RUSH_WEAK //
CREATE FUNCTION RUSH_WEAK(
	date_param date,
	team_id_param INT
)
	RETURNS INT
    	BEGIN
        DECLARE rush_allwd INT;
	SELECT
		AVG(recent.opp_rush) INTO rush_allwd
	FROM
		(SELECT
			full_game_stats.t2_rush opp_rush
		FROM full_game_stats
        	WHERE 1=1
			AND full_game_stats.t1_id = team_id_param
                	AND full_game_stats.game_date < date_param
		ORDER BY full_game_stats.game_date DESC
		LIMIT 10) recent;
        RETURN rush_allwd;
	END //
DELIMITER ;

/*
* Create function determine pass weakness for a team on a given data.
* Weakness is determined by the average of the team's opponents' net rushing over the last 10 games
*/

DELIMITER //
DROP FUNCTION IF EXISTS PASS_WEAK //
CREATE FUNCTION PASS_WEAK(
	date_param date,
	team_id_param INT
)
	RETURNS INT
    	BEGIN
        DECLARE pass_allwd INT;
	SELECT
		AVG(recent.opp_pass) INTO pass_allwd
	FROM
		(SELECT
			full_game_stats.t2_pass opp_pass
		FROM full_game_stats
        	WHERE 1=1
			AND full_game_stats.t1_id = team_id_param
                	AND full_game_stats.game_date < date_param
		ORDER BY full_game_stats.game_date DESC
		LIMIT 10) recent;
        RETURN pass_allwd;
	END //
DELIMITER ;

/*
* Create final table for our feature vectors. 
* Each row represents a game, with stats on the teams playing, venue, and weather for gameday.
*/
DROP TABLE IF EXISTS game_data;
CREATE TABLE game_data (
    game_date DATE,
    team_id INT,
    rush_strength INT,
    pass_strength INT,
    opp_rush_weak INT,
    opp_pass_weak INT,
    venue VARCHAR(20),
    precipitation DOUBLE,
    snow DOUBLE
);
INSERT INTO game_data(
    game_date,
    team_id,
    rush_strength,
    pass_strength,
    opp_rush_weak,
    opp_pass_weak,
    venue,
    precipitation,
    snow
    )
SELECT
    full_game_stats.game_date,
    full_game_stats.t1_id AS team_id,
    RUSH_STREN(full_game_stats.game_date, full_game_stats.t1_id),
    PASS_STREN(full_game_stats.game_date, full_game_stats.t1_id),
    RUSH_WEAK(full_game_stats.game_date, full_game_stats.t2_id),
    PASS_WEAK(full_game_stats.game_date, full_game_stats.t2_id),
    game.location,
    CAST(prcp AS DECIMAL(5,2)),
    CAST(snow AS DECIMAL(5,2))
FROM full_game_stats
JOIN team ON 1=1
    AND full_game_stats.t1_id = team.team_id
JOIN game ON 1=1
    AND full_game_stats.game_id = game.game_id
JOIN weather ON 1=1
    AND team.station_id = weather.station_id
    AND full_game_stats.game_date = weather.gdate;

/* Update null weather values to 0 */
UPDATE game_data SET
    precipitation = IFNULL(precipitation, 0),
    snow = IFNULL(snow, 0);
