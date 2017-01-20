#!/bin/bash

# A script to incrementaly load weather data into MySQL.
# Looks for dayly updates and imports them.

IMPORTFILE="$PWD/yesterdays_data_import.csv"
AIRPORTIDS="$PWD/airportids.txt"
YEAR=$(date --date="2 days ago" +"%Y")
MONTH=$(date --date="2 days ago" +"%-m")
DAY=$(date --date="2 days ago" +"%-d")

mysql -e "create database if not exists weather_data;"

while read AIRPORTID; do 
  echo Loading data for airport $AIRPORTID for the $MONTH/$DAY/$YEAR...
  wget -q -O $IMPORTFILE  "http://www.wunderground.com/history/airport/$AIRPORTID/$YEAR/$MONTH/$DAY/CustomHistory.html?dayend=$DAY&monthend=$MONTH&yearend=$YEAR&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=&format=1"
  cat $IMPORTFILE

  mysql -e "use weather_data;
    create table if not exists $AIRPORTID (
    PST DATE,
    Max_TemperatureF VARCHAR(255),
    Mean_TemperatureF VARCHAR(255),
    Min_TemperatureF VARCHAR(255),
    Max_Dew_PointF VARCHAR(255),
    MeanDew_PointF VARCHAR(255),
    Min_DewpointF VARCHAR(255),
    Max_Humidity VARCHAR(255),
    Mean_Humidity VARCHAR(255),
    Min_Humidity VARCHAR(255),
    Max_Sea_Level_PressureIn VARCHAR(255),
    Mean_Sea_Level_PressureIn VARCHAR(255),
    Min_Sea_Level_PressureIn VARCHAR(255),
    Max_VisibilityMiles VARCHAR(255),
    Mean_VisibilityMiles VARCHAR(255),
    Min_VisibilityMiles VARCHAR(255),
    Max_Wind_SpeedMPH VARCHAR(255),
    Mean_Wind_SpeedMPH VARCHAR(255),
    Max_Gust_SpeedMPH VARCHAR(255),
    PrecipitationIn VARCHAR(255),
    CloudCover VARCHAR(255),
    Events VARCHAR(255),
    WindDirDegrees VARCHAR(255)
  );"


  mysql -e "use weather_data; LOAD DATA INFILE '$IMPORTFILE' INTO TABLE $AIRPORTID FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 ROWS;"
done < $AIRPORTIDS

