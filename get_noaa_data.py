# Kyle Hart
# 04 Sept 2017
#
# Project: football_predictions
# File: get_noaa_data.py
# Description: Uses NOAA's Climate Data Online web API to get data for each of our schools from the years 2008-2012
#           The data is then inserted into our MySQL database's raw_weather table

from cdo_api_py import Client
import pandas as pd
from _datetime import datetime
import MySQLdb
from sqlalchemy import create_engine
from pprint import pprint

def connect():
    '''
    Callable required to create a sql alchemy engine
    :return: connection to db
    '''
    return MySQLdb.connect(host='localhost', port=3306, user='root', passwd="##############", db='league')

def get_year_of_data(client, station_list, year):
    '''
    Main function sends calls to the NOAA cdo_api asking for a all data within a given year for the each of the stations listed.
    Api calls return a Pandas Dataframe which is then sent to the raw_weather table in our MySQL database
    '''
    startdate = datetime(year, 8, 1)
    enddate = datetime((year+1), 2, 1)

    # DataFrame to iterate through for stations cdo_api function required
    frame = {'id': station_list}
    stations = pd.DataFrame(data=frame)

    # Create a SqlAlchemy engine with the existing connection, then passed into pandas.to_sql
    db_engine = create_engine('mysql://', creator=connect)

    for rows, station in stations.iterrows():
        station_data = client.get_data_by_station(
            datasetid='GHCND',
            stationid=station['id'],
            startdate=startdate,
            enddate=enddate,
            return_dataframe=True
            # include_station_meta=True
        )
        # Create new DataFrame limiting columns (we don't want ALL of the station data)
        columns = ['station', 'date', 'PRCP', 'SNOW']
        single = pd.DataFrame(station_data, columns=columns)
        # Send to database
        single.to_sql(con=db_engine, name='raw_weather',if_exists='append', index=False)


# Connect to DB
conn = connect()
cursor = conn.cursor()

# Get list of stations
cursor.execute('SELECT DISTINCT station_id FROM team')
station_list = [ row[0] for row in cursor.fetchall()]

# Set params for API call
token = '############'
client = Client(token, default_units='metric', default_limit=1000)

for years in range(2008,2013):
    get_year_of_data(client, station_list, years)


conn.close()
