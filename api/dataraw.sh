#!/usr/bin/env bash
echo "Content-Type: text/plain"
echo 

# $1 till $8 parameter
# get parameter from the getFormInput file 

begin=$1
end=$2
air_temperatur=$3
air_pressure=$4
wind_direction=$5
wind_speed=$6
humidity=$7

API_URL="https://dashboard.awi.de/data-xxl/rest/data?beginDate=$begin&endDate=$end&format=text/tab-separated-values&aggregate=minute&aggregateFunctions=MEAN&sensors=vessel:heincke:saab:latitude\$NRT&sensors=vessel:heincke:saab:longitude\$NRT&sensors=vessel:heincke:dwd:air_temperature\$NRT&sensors=vessel:heincke:dwd:air_pressure\$NRT&sensors=vessel:heincke:dwd:absolute_wind_speed\$NRT&sensors=vessel:heincke:dwd:absolute_wind_direction\$NRT&sensors=vessel:heincke:dwd:humidity\$NRT"

# echo "$begin\n $end"

# storage API in a variable
#api=$(curl -s "$API_URL")  

#echo "$api" | sed '1d' > rev.csv

#echo "$api" | sed '1d' | while IFS=$'\t' read -r col1 col2 col3 col4 col5 col6 col7 col8
#do 
#  echo "$col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8" 
#done


####### ######## ######  mmethod2 ####### ###### ######
# Convert to ISO 8601 format
begin_iso=$(date -u -d "$begin" '+%Y-%m-%dT%H:%M:%S')
end_iso=$(date -u -d "$end" '+%Y-%m-%dT%H:%M:%S')

domain="https://dashboard.awi.de/data-xxl/rest/data?"
datelimit="beginDate=$begin_iso&endDate=$end_iso"
other="&format=application/json&aggregate=hour&aggregateFunctions=MEAN"
parameter="&sensors=vessel:heincke:saab:longitude\$NRT&sensors=vessel:heincke:saab:latitude\$NRT&sensors=vessel:heincke:dwd:air_temperature\$NRT&sensors=vessel:heincke:dwd:air_pressure\$NRT&sensors=vessel:heincke:dwd:absolute_wind_direction\$NRT&sensors=vessel:heincke:dwd:absolute_wind_speed\$NRT&sensors=vessel:heincke:dwd:humidity\$NRT"

# url concatenate 
url=${domain}${datelimit}${other}${parameter}

# echo "$url"

head='[vessel:heincke:saab:longitude$NRT\|vessel:heincke:saab:latitude$NRT\|vessel:heincke:dwd:air_temperature$NRT\|vessel:heincke:dwd:air_pressure$NRT\|vessel:heincke:dwd:absolute_wind_direction$NRT\|vessel:heincke:dwd:absolute_wind_speed$NRT\|vessel:heincke:dwd:humidity$NRT\|]'

# grep -v $head # delete the $head charactere
# sed '1s/^\[//; $s/\]$//' # delete the opening and closing brackets

test=$(curl -s "$url" | jq '.[]' | grep -v "$head" | sed '/^\s*\[\s*\]\s*$/d' | sed ':a;N;$!ba;s/\[\n\]//g' | jq 'map(.[0:2])' | jq -c "." | sed '1s/^\[//; $s/\]$//')
echo "$test" # > output.txt

lat=$(echo "$test" | jq "map(.[0])")
long=$(echo "$test" | jq "map(.[1])")
air_t=$(echo "$test" | jq "map(.[2])")
air_p=$(echo "$test" | jq "map(.[3])")
wind_s=$(echo "$test" | jq "map(.[4])")
wind_d=$(echo "$test" | jq "map(.[5])")
hum=$(echo "$test" | jq "map(.[6])")

#echo -e "$lat \t $long \t $air_temp \t $air_press \t $wind_speed \t $wind_direct \t $humidity "

# check if variables are set to "on"
if [ -n "$air_temperatur"];
then
  # here calling ajax function
  echo  
fi

if [ -n "$air_pressure"];then
  # here calling ajax function
  echo 
fi

if [ -n "$wind_direction"];then
  # here calling ajax function
  echo 
fi

if [ -n "$wind_speed" ];then
  # here calling ajax function
  echo 
fi

if [ -n "$humidity"];then
  # here calling ajax function
  echo 
fi


