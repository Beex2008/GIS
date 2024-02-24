#!/usr/bin/env bash
echo 'Content-Type: text/html'
echo 
echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>'
echo '  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">'
echo '  <meta name="viewport" content="width=device-width, initial-scale=1">'

echo '  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />'
echo '  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>'

echo "  <style>"
cat styles.txt
echo "</style>"

# echo '  <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap rel="stylesheet">'
echo '    <title>Dashboard</title>'
echo '</head>'
echo "<body>"

#echo '    <div class="overlay">'
#echo '      <h1>Parameters auswählen</h1>'
#echo '      <form id="set_params"> <!--action="/docker-knzilewis-web/cgi-bin/api/getFormInput.sh">-->'
#echo '        <label for="begin_date">Start</label><input type="date" name="begin_date" id="begin_date" max="2024-02-22">'
#echo '        <label for="end_date">Ende</label><input type="date" name="end_date" id="end_date"  max="2024-02-22">'
#echo '        <label for="air_temperature">Lufttemperatur</label><input type="checkbox" name="air_temperature" id="air_temperature">'
#echo '        <label for="air_pressure">Luftdruck</label><input type="checkbox" name="air_pressure" id="air_pressure">'
#echo '        <label for="wind_direction">Windrichtung</label><input type="checkbox" name="wind_direction" id="wind_direction">'
#echo '        <label for="wind_speed">Windgeschwindigkeit</label><input type="checkbox" name="wind_speed" id="wind_speed">'
#echo '        <label for="humidity">Luftfeuchtigkeit</label><input type="checkbox" name="humidity" id="humidity">'
#echo ''
#echo '        <label for="entry">Einträge:</label>'
#echo '        <input type="range" min="10" max="20000" value="50" step="10" id="entry" name="entry">'
#echo ''
#echo '        <p>Anzahl:</p> <span id="sliderValue">50</span>'
#echo '        <button type="submit" style="background-color: rgb(68, 66, 226);">Senden</button>'
#echo '        <button type="button" onClick="resetForm()" style="background-color: rgb(209, 91, 91);">Zurücksetzen</button>'
#echo '      </form>'
#echo '    </div>'
echo '    <div id="map"></div>'

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

echo '    <script>'
echo '      window.onload = mapShow'
echo "      document.addEventListener('DOMContentLoaded', function () {"
echo '        var output = document.getElementById("sliderValue");'
echo '        var slider = document.getElementById("entry");'
echo ''
echo '        var beginDate = document.getElementById("begin_date").value;'
echo '        var endDate = document.getElementById("end_date").value;'
# get value from Checkbox
echo '        var airTemperature = document.getElementById("air_temperature").checked;'
echo '        var airPressure = document.getElementById("air_pressure").checked;'
echo '        var windDirection = document.getElementById("wind_direction").checked;'
echo '        var windSpeed = document.getElementById("wind_speed").checked;'
echo '        var humidity = document.getElementById("humidity").checked;'


echo '        output.innerHTML = slider.value;'
echo '        slider.oninput = function() {'
echo '          output.innerHTML = slider.value;'
echo '        }'
echo '      });'
#echo '      setInterval(() => {'
#echo '        sendData();'
#echo '      },2000);'
echo ''
echo '        function sendData(event) {'
echo '        if(event) {event.preventDefault();} '
echo '        var xhr = new XMLHttpRequest();'
echo '        var url = "getFormInput.sh";'

echo "        var form_data = new FormData(document.getElementById('set_params'));"
echo '        var queryString = new URLSearchParams(form_data).toString();'
echo '        url += "?" + queryString;'
echo ''
echo '        xhr.open("GET", url, true);'
echo '        xhr.onreadystatechange = function () {'
echo '            if (xhr.readyState === 4 && xhr.status === 200) {'
echo '                console.log(xhr.responseText);'
echo "              document.getElementById("map").innerHTML =xhr.responseText;"
#          numberOfItem=$(curl -s "$url" | jq '.[] | length')
#          nb=$(echo $numerOfItem)
#echo "          alert($nb);"
echo '      }  };'
echo '        xhr.send();'
echo '    }'
echo "      document.getElementById('set_params').addEventListener('submit', sendData);"

echo 
echo '      function mapShow() {'
echo "        map = L.map('map').setView([53.549999, 8.583333], 16);"


# google street layer
echo "        googleStreet = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {"
echo '          maxZoom: 19,'
echo "        attribution: '&copy; <a href=\"http://www.openstreetmap.org/copyright\">OpenStreetMap</a>'});"

echo '        googleStreet.addTo(map);'
echo "        var locations = [$test];"

echo "        locations.forEach(function(loc) {
                L.marker(loc).addTo(map);
               }); "
#echo "      var marker = L.marker($test).addTo(map);"

echo '      }'
echo '      function resetForm() {'
echo '       document.getElementById("set_params").reset();'
echo '        document.getElementById("sliderValue").innerHTML = "50";'
echo '      }'
echo '    </script>'
echo '  </body>'
echo '</html>'

