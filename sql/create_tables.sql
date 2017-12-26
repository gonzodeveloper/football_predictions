/*
* Kyle Hart
* 2 Sept 2017
*
* Project: football_predictions
* File: create_tables.sql
* Description: Creates database schema and tables for the RAW tables
*
*/

CREATE DATABASE IF NOT EXISTS league;
USE league;

DROP TABLE IF EXISTS raw_schedule;
CREATE TABLE raw_schedule(
    team_id int,
    team_name varchar(50),
    game_date varchar(50),
    opp_id int,
    opp_name varchar(50),
    team_score int,
    opp_score int,
    location varchar(20)
);

DROP TABLE IF EXISTS raw_offense;
CREATE TABLE raw_offense(
    team_id int,
    team_name varchar(50),
    game_date varchar(50),
    uniform_num int,
    lname varchar(25),
    fname varchar(25),
    rush_att int,
    rush_gain int,
    rush_loss int,
    rush_net int,
    rush_td int,
    pass_att int,
    pass_cmp int,
    pass_intc int,
    pass_yards int,
    pass_td int,
    pass_conv int,
    ttl_plays int,
    ttl_yards int,
    rec_cmp int,
    rec_yards int,
    rec_td int,
    intc_cmp int,
    intc_yards int,
    intc_td int,
    fumb_cmp int,
    fumb_yards int,
    fumb_td int,
    punt_cmp int,
    punt_yards int,
    punt_ret_cmp int,
    punt_ret_yards int,
    punt_ret_td int,
    ko_ret_cmp int,
    ko_ret_yards int,
    ko_ret_td int,
    ttl_td int,
    off_xpts_kck_att int,
    off_xpts_kck_cmp int,
    off_xpts_rp_att int,
    off_xpts_rp_cmp int,
    def_xpts_kck_att int,
    def_xpts_kck_cmp int,
    def_xpts_intcfum_att int,
    def_xpts_intcfum_cmp int,
    fg_att int,
    fg_cmp int,
    safty int,
    ttl_pts int
);

DROP TABLE IF EXISTS raw_defense;
CREATE TABLE raw_defense(
    team_id int,
    team_name varchar(50),
    game_date varchar(50),
    uniform_num int,
    lname varchar(25),
    fname varchar(25),
    tckl_unasst int,
    tckl_asst int,
    tckl_loss_unasst int,
    tckl_loss_asst int,
    tckl_loss_yards int,
    sack_unasst int,
    sack_asst int,
    sack_yards int,
    sack_cmp int,
    pass_brkup int,
    forcd_fum int,
    qb_hurries int,
    blckd_kcks int
);

DROP TABLE IF EXISTS raw_schools;
CREATE TABLE raw_schools(
	team_id int,
    station_id VARCHAR(20)
);

DROP TABLE IF EXISTS raw_weather;
CREATE TABLE raw_weather(
    station VARCHAR (20),
    date VARCHAR(30),
    PRCP DOUBLE,
    SNOW DOUBLE
);
