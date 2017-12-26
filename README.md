# football_predictions

**Using the k-Nearest Neighbors Algorithm to Predict College Football**

This project is split into two parts: construction of the league database and analysis using the k-NN algorithm.

**The Dataset**

Because I use this dataset for multiple projects. I'll include a separate explination for the database architecture. To download the raw csv's and load them into our database simply create a mysql database called "league" and run the scripts in the order specified by the file "building_dataset.txt". 

The creating of the 5 base tables (team, game, player, preformance, and weather) as well as the 2 views is straight forward enough, and these will be used in later programs. 

![]({{site.baseurl}}/ football_predictions/schema.png )

![](https://github.com/gonzodeveloper/football_predictions/blob/master/schema.png)
For the k-NN analysis we had to create the game_data table which aggregates teams' strenghts and weaknesses (see below). The table was loaded with the help of several user defined functions. The script works well enough, however it would have been much faster and simpler to use mysql's built in WINDOW fucntions to calculate the "strength" and "weakness" figures.

**Analysis**

For now the goal of this project is not necessarily to predict the outcome of NCAA football games, rather to predect the rushing preformance of a team given that we know their recent preformance stats as well as their opponent's, and the precipitation/snow figures for game day. The logic informing this analysis is as follows. We can score a teams strength in offensive passing and rushing as well as their weakness in defending against it by aggregating stats from their recent games. Moreover, we know that a team will usually change its play-style in favor of rushing in inclement weather--it's much harder to throw a pass in the rain or snow. Therefore, we can take these "strength" and "weakness" figures, along with precipitation data, as feature vectors for a game. Then, we can the plot each vector (i.e., game) in hyper-dimensional space and the nearest neighbors will represent similar games. If we know that rushing yards for those games, we can predict for our testing data.

**Results**
 
**############## DATA ON RUSH YDS PER GAME ##############**

Mean = 193.6229799851742

Median = 164.0 

Max = 1142

Min = -64 

Std Dev = 135.56466770854033 

Error of prediction is 54.18799110452187 yards

**#######################################################** 

So, it seems the program did not run well. The average error of prediction was nearly half of a standard deviation. There are several factors that could have lead to this failure.

	- No normalization of data, or removal of outliers
    - Bad data or data that was corrupted during to collation process (i.e., I might have screwed up some values in the various transactions and aggregations I ran in SQL)
    - Incorrect assumptions on the data; the 10 game average for determining rush/pass strength was arbitrary. Other values might yield better results.
    - Anonymity of data; because I never put any sort of ranking system in place, a mediocre team that rushed very well against a series of terrible teams would have a better rush_strength than a great team that preformed OK against other great teams.
    - Any Given Sunday…
    - The k-nearest neighbor method of predictive data analysis might actually not be that great.

