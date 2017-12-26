# Kyle Hart
# 11 Sept 2017
#
# Project: football_predictions
# File: analyze.py
# Description: Uses aggregated NCAAF and weather data to make predictions on rushing prerofmances of given games
#              To make predictions we use the K Nearest Neighbors classifier model for the sklearn library
#              Each "point" determined by stat numbers on the teams playing, and weather data for game day
#              To make a prediction, we find outcomes of the k-nearest neighbors (representing similar games)

import MySQLdb
import re
import numpy
from sklearn.neighbors import KNeighborsClassifier

def getMeanAbsError(predicted, actual):
    '''
    Given lists of predicted scores and actual scores we find the mean absolute error 
    '''
    n = len(predicted)
    totalerr = 0
    for i in range(n):
        totalerr += abs(predicted[i]-actual[i])
    return (totalerr/n)

def printStats(array):
    '''
    Prints a number of generic statistics on an array of rushing data (listed per game)
    '''
    data_mean = numpy.mean(array)
    data_median = numpy.median(array)
    data_stddev = numpy.std(array)
    data_min = numpy.amin(array)
    data_max = numpy.amax(array)
    print("##### DATA ON RUSH YDS PER GAME ####")
    print("Mean = {}".format(data_mean))
    print("Median = {}".format(data_median))
    print("Max = {}".format(data_max))
    print("Min = {}".format(data_min))
    print("Std Dev = {}".format(data_stddev))

if __name__ == "__main__":
    #Connect to database
    conn = MySQLdb.connect(host='localhost', port=3306, user='root', passwd="############", db='league')
    curs = conn.cursor()
    print("Loading data... \n")
    # General Query
    query = 'SELECT ' \
	            'CAST(game_stats.rush AS SIGNED), ' \
                'game_data.rush_strength, '\
                'game_data.pass_strength, '\
                'game_data.opp_rush_weak, '\
                'game_data.opp_pass_weak, '\
                'game_data.precipitation, ' \
                'game_data.snow '\
                'FROM game_data '\
                'JOIN game_stats ON 1=1 '\
		            'AND game_data.team_id = game_stats.team_id '\
		            'AND game_data.game_date = game_stats.game_date '\
                'WHERE 1=1 '\
		            'AND YEAR(game_data.game_date) <= 2010 ' \
                    'AND rush_strength IS NOT NULL ' \
                    'AND pass_strength IS NOT NULL ' \
                    'AND opp_rush_weak IS NOT NULL ' \
                    'AND opp_pass_weak IS NOT NULL ' \
                    'AND precipitation IS NOT NULL ' \
                    'AND snow IS NOT NULL '
    # Get Training Data ( all games from 2008-2010 )
    curs.execute(query)
    train_raw = curs.fetchall()
    train_rush = [ row[0] for row in train_raw ]
    train_stats = [ row[1:6] for row in train_raw ]

    # Get Test Data ( all games after 2010 )
    query = re.sub('<=', '>', query)
    curs.execute(query)
    test_raw = curs.fetchall()
    actual_rush = [ row[0] for row in test_raw ]
    test_stats = [ row[1:6] for row in test_raw ]
    print("Training the machine... \n")
    #Train data with classifier using k-nearest neighbors technique
    machine = KNeighborsClassifier( n_neighbors=5, weights='distance', algorithm='kd_tree', n_jobs=-1)
    machine.fit(train_stats, train_rush)
    # Predictions and error
    print("Making predictions...\n")
    predicted_rush = machine.predict(test_stats)

    printStats(actual_rush)
    error = getMeanAbsError(predicted_rush, actual_rush)
    print("Error of prediction is {} yards".format(error))
