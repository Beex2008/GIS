#!/usr/bin/env bash 
echo "Content-Type: text/plain"
echo 

echo "$QUERY_STRING"
input="$QUERY_STRING"

# split the input with regex command
begin_date=$(echo "$input" | grep -o "begin_date=[^&]*" | cut -d'=' -f2)
end_date=$(echo "$input" | grep -o "end_date=[^&]*" | cut -d'=' -f2)
air_temperature=$(echo "$input" | grep -o "air_temperature=[^&]*" | cut -d'=' -f2)
air_pressure=$(echo "$input" | grep -o "air_pressure=[^&]*" | cut -d'=' -f2)
wind_direction=$(echo "$input" | grep -o "wind_direction=[^&]*" | cut -d'=' -f2)
wind_speed=$(echo "$input" | grep -o "wind_speed=[^&]*" | cut -d'=' -f2)
humidity=$(echo "$input" | grep -o "humidity=[^&]*" | cut -d'=' -f2)
entry=$(echo "$input" | grep -o "entry=[^&]*" | cut -d'=' -f2)


# check the value from the url
echo "Von: $begin_date"
echo "Bis: $end_date"
echo "Lufttemperature: $air_temperature"
echo "Luftdruck: $air_pressure"
echo "Windrichtung: $wind_direction"
echo "Windgeschwindigkeit: $wind_speed"
echo "Luftfeuchtigkeit: $humidity"
echo "Einträge: $entry"

# convert datetime in datetime UTC format 
# converted_begin=$(date -u -d "$begin_date" +"%Y-%m-%dT00:00:00")
# converted_end=$(date -u -d "$end_date" +"%Y-%m-%dT00:00:00")
# converted_begin=$(date -u -d "$begin" +"%Y-%m-%dT%H:%M:%S")
# converted_end=$(date -u -d "$end" +"%Y-%m-%dT%H:%M:%S")

./map.sh $begin_date $end_date $air_temperature $air_pressure $wind_direction $wind_speed $humidity $entry

