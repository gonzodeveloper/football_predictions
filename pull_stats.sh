#!/bin/bash
#
# Kyle Hart
# 2 Sept 2017
#
# Project: football_predictions
# File: pull_stats.sh
# Description: Downloads raw game stats from NCAA website and saves to 'raw' directory in project folder

rw="raw"
dir=`pwd`
rawdir=$dir/$rw

echo "Downloading Statistics..."
if [ ! -d $rawdir ];
then
    mkdir raw
fi

cd raw
for year in {2008..2012}
do
    wget http://web1.ncaa.org/mfb/$year/Internet/player%20stats/DIVISIONB.csv
    mv DIVISIONB.csv offense_$year.csv
    wget http://web1.ncaa.org/mfb/$year/Internet/player%20stats/DIVISIONBdefense.csv
    mv DIVISIONBdefense.csv defense_$year.csv
    wget http://web1.ncaa.org/mfb/$year/Internet/schedule/DIVISIONB.csv
    mv DIVISIONB.csv schedule_$year.csv
done
cd ..
echo "Complete!"

exit 0
