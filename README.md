# football_predictions

**** Using the k-Nearest Neighbors Algorithm to Predict College Football 

This project is split into two parts. 
For now the goal of this project is not necessarily to predict the outcome of NCAA football games, rather to predect the rushing preformance of a team given that we know their recent preformance stats as well as their opponent's, and the precipitation/snow figures for game day. The logic informing this analysis is as follows. We can score a teams strength in offensive passing and rushing as well as their weakness in defending against it by aggregating stats from their recent games. Moreover, we know that a team will usually change its play-style in favor of rushing in inclement weather--it's much harder to throw a pass in the rain or snow. Therefore, we can take these "strength" and "weakness" figures, along with precipitation data, as feature vectors for a game. Then, we can the plot each vector (i.e., game) in hyper-dimensional space and the nearest neighbors will represent similar games. If we know that rushing yards for those games, we can predict for our testing data.

