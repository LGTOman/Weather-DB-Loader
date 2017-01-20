#!/bin/bash

# A script to import weather data into MySQL

IMPORTFILE="$PWD/data_import.csv"
AIRPORTIDS="$PWD/airportids.txt"
let YEAR=1997

mysql -e "create database if not exists weather_data;"

while [ $YEAR -le $(date +"%Y") ] ; do 
  while read AIRPORTID; do 
    echo Loading data for airport $AIRPORTID for the year $YEAR...
    wget -q -O $IMPORTFILE  "http://www.wunderground.com/history/airport/$AIRPORTID/$YEAR/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=$YEAR&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=&format=1"

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


    mysql -e "use weather_data; LOAD DATA LOCAL INFILE '$IMPORTFILE' INTO TABLE $AIRPORTID FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 ROWS;" 
  done < $AIRPORTIDS

  let YEAR=$YEAR+1
done
