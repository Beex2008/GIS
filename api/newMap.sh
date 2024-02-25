#!/usr/bin/env bash
echo 'Content-Type: application/json'
echo

# calling script from formData
# ./getFormInput.sh

# get parameter from the getFormInput file
begin=$1
end=$2
air_temperatur=$3
air_pressure=$4
wind_direction=$5
wind_speed=$6
humidity=$7


# Convert to iso format
begin_iso=$(date -u -d "$begin" '+%Y-%m-%dT%H:%M:%S.000')
end_iso=$(date -u -d "$end" '+%Y-%m-%dT%H:%M:%S.000')

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

#test=$(curl -s "$url" | jq '.[]' | grep -v "$head" | sed '/^\s*\[\s*\]\s*$/d' | sed ':a;N;$!ba;s/\[\n\]//g' | jq 'map(.[0:2])'|jq 'map({lat: .[0], lng: .[1]})' | jq -c "." | sed '1s/^\[//; $s/\]$//')

#test=$(curl -s "$url" | jq '.[]' | grep -v "$head" | sed '/^\s*\[\s*\]\s*$/d' | sed ':a;N;$!ba;s/\[\n\]//g' | jq 'map(.[0:2])' | jq 'map({lat: .[1], lng: .[0]})' | jq -c ".")

test=$(curl -s "$url" )

echo "$test"

#lat=$(echo "$test" | jq "map(.[0])")
#long=$(echo "$test" | jq "map(.[1])")
#air_t=$(echo "$test" | jq "map(.[2])")
#air_p=$(echo "$test" | jq "map(.[3])")
#wind_s=$(echo "$test" | jq "map(.[4])")
#wind_d=$(echo "$test" | jq "map(.[5])")
#hum=$(echo "$test" | jq "map(.[6])")

