#!/bin/bash
# Simle weather script which does following.
# Written by MR.
#
# What it does:
# 1. Each time it runs, LOCAL_XML_FILE is checked. If the file does not exist, or it is older than XML_FILE_MAX_AGE seconds, then:
#   a. It is redownloaded.
#   b. All weather pictures are copied.
# 2. It prints out requested information.

# System constants.
EXIT_SUCCESS=0
EXIT_FAILURE=1

if [[ $# == 0 ]]; then
  echo "Error! Run 'cat $0' for more info."
  exit $EXIT_SUCCESS
fi

# Constants.
LOCATION_ID=795429
WEATHER_API_ENDPOINT="http://weather.yahooapis.com/forecastrss?w=$LOCATION_ID&u=c"
ROOT_SETTINGS_FOLDER=$HOME/.martin/conky
PICTURES_FOLDER=$ROOT_SETTINGS_FOLDER/images
ICONS_FOLDER=$ROOT_SETTINGS_FOLDER/images/icons
ICONS_PREFIX=weather
CACHE_FOLDER=$ROOT_SETTINGS_FOLDER/cache
LOCAL_XML_FILE=$CACHE_FOLDER/weather.xml
XML_FILE_MAX_AGE=260

# Check if XML weather file exists or is not too old. If one of those conditions is not met
# then download new version.
CURRENT_TIME_SECONDS=$(date +%s)

if [[ !(-r $LOCAL_XML_FILE) || $(($CURRENT_TIME_SECONDS - $(date -r $LOCAL_XML_FILE +%s))) > $XML_FILE_MAX_AGE ]]; then
  # XML weather data file either does not exist or it is too old. Download it.
  curl -s $WEATHER_API_ENDPOINT -o $LOCAL_XML_FILE >/dev/null 2>&1

  if [[ $? != $EXIT_SUCCESS ]]; then
    # File was not downloaded, this is big problem.
    echo problem
    exit $EXIT_FAILURE
  else
    # File was updated and downloaded. Now refresh icons and make further actions.
    cp -f $ICONS_FOLDER/$(grep "yweather:forecast" $LOCAL_XML_FILE | grep -o "code=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk 'NR==2').png $CACHE_FOLDER/$ICONS_PREFIX-1.png
    cp -f $ICONS_FOLDER/$(grep "yweather:forecast" $LOCAL_XML_FILE | grep -o "code=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk 'NR==3').png $CACHE_FOLDER/$ICONS_PREFIX-2.png
    cp -f $ICONS_FOLDER/$(grep "yweather:forecast" $LOCAL_XML_FILE | grep -o "code=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk 'NR==4').png $CACHE_FOLDER/$ICONS_PREFIX-3.png
  fi
fi

# All artifacts are downloaded, return requested data.

case $1 in
  # Get current temperature.
  -current-temp)
    TEMPERATURE=$(grep "yweather:condition" $LOCAL_XML_FILE | grep -o "temp=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    echo $TEMPERATURE°
    ;;

  -current-city-status)
    CITY=$(grep "yweather:location" $LOCAL_XML_FILE | grep -o "city=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    STATUS=$(grep "yweather:condition" $LOCAL_XML_FILE | grep -o "text=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | tr A-Z a-z)
    echo $CITY - $STATUS
    ;;

  # Get current humidity.
  -current-humidity)
    HUMIDITY=$(grep "yweather:atmosphere" $LOCAL_XML_FILE | grep -o "humidity=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    echo $HUMIDITY %
    ;;

  # Get current wind.
  -current-wind)
    WIND=$(grep "yweather:wind" $LOCAL_XML_FILE | grep -o "speed=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    WIND_UNIT=$(grep "yweather:units" ~/.martin/conky/cache/weather.xml | grep -o "speed=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    echo $WIND $WIND_UNIT
    ;;

  # Get current pressure.
  -current-pressure)
    PRESSURE=$(grep "yweather:atmosphere" $LOCAL_XML_FILE | grep -o "pressure=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    PRESSURE_UNIT=$(grep "yweather:units" $LOCAL_XML_FILE | grep -o "pressure=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*")
    echo $PRESSURE $PRESSURE_UNIT
    ;;

  # Forecast options require second argument - number of day in the future.
  # Example ./weather.sh -forecast-dayname 1 return name of the first forecast day in the future.

  # Get forecast day name.
  -forecast-dayname)
    grep "yweather:forecast" $LOCAL_XML_FILE | grep -o "day=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk "NR==$(($2 + 1))" | tr '[a-z]' '[A-Z]'
    ;;

  # Get forecast day temperatures.
  -forecast-temps)
    LOWER_TEMP=$(grep "yweather:forecast" ~/.martin/conky/cache/weather.xml | grep -o "low=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk "NR==$(($2 + 1))")
    UPPER_TEMP=$(grep "yweather:forecast" ~/.martin/conky/cache/weather.xml | grep -o "high=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | awk "NR==$(($2 + 1))")
    echo $LOWER_TEMP°/$UPPER_TEMP°
    ;;
esac

exit $EXIT_SUCCESS