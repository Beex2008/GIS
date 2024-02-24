#!/usr/bin/env bash
echo 'Content-Type: text/html'
echo 
echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>'
echo '  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">'
echo '  <meta name="viewport" content="width=device-width, initial-scale=1">'
echo '  <link rel="stylesheet" href="css/styles.css" />'
echo '  <!-- leaflet cdn link -->'
echo '  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"'
echo '    integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />'
echo '  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>'
echo "  <style>"
cat styles.txt
echo "</style>"

echo ' <!-- <script src="js/script.js"></script>-->'
echo ' <!-- <script src="js/api.js"></script>-->'
echo '  <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap rel="stylesheet">'
echo '    <title>Leaflet Sensors DataView</title>'
echo '</head>'

echo '<body>'


echo "$QUERY_STRING" 
input="$QUERY_STRING"

# split the input with regex command 
begin_date=$(echo "$input" | grep -o "begin_date=[^&]*" | cut -d'=' -f2)
end_date=$(echo "$input" | grep -o "end_date=[^&]*" | cut -d'=' -f2)
air_pressure=$(echo "$input" | grep -o "air_pressure=[^&]*" | cut -d'=' -f2)
wind_direction=$(echo "$input" | grep -o "wind_direction=[^&]*" | cut -d'=' -f2)
wind_speed=$(echo "$input" | grep -o "wind_speed=[^&]*" | cut -d'=' -f2)
humidity=$(echo "$input" | grep -o "humidity=[^&]*" | cut -d'=' -f2)
entry=$(echo "$input" | grep -o "entry=[^&]*" | cut -d'=' -f2)

# check the value from the url
echo "Von: $begin_date"
echo "Bis: $end_date"
echo "Luftdruck: $air_pressure"
echo "Windrichtung: $wind_direction"
echo "Windgeschwindigkeit: $wind_speed"
echo "Luftfeuchtigkeit: $humidity"
echo "Einträge: $entry"

echo '  <div class="overlay">'
echo '    <h1>Parameters auswählen</h1>'
echo '    <form id="set_params">'
echo '      <label for="begin_date">Start</label><input type="date" name="begin_date" id="begin_date" max="2024-02-22">'
echo '      <label for="end_date">Ende</label><input type="date" name="end_date" id="end_date"  max="2024-02-22">'
echo '      <label for="air_temperature">Lufttemperatur</label><input type="checkbox" name="air_temperature"'
echo '        id="air_temperature">'
echo '      <label for="air_pressure">Luftdruck</label><input type="checkbox" name="air_pressure" id="air_pressure">'
echo '      <label for="wind_direction">Windrichtung</label><input type="checkbox" name="wind_direction" id="wind_direction">'
echo '      <label for="wind_speed">Windgeschwindigkeit</label><input type="checkbox" name="wind_speed" id="wind_speed">'
echo '      <label for="humidity">Luftfeuchtigkeit</label><input type="checkbox" name="humidity" id="humidity">'
echo '      <label for="entry">Einträge:</label>'
echo '      <input type="range" min="10" max="20000" value="50" step="10" id="entry" name="entry">'
echo '      <p>Anzahl:</p> <span id="sliderValue">50</span>'
echo '      <button type="submit" style="background-color: rgb(68, 66, 226);">Senden</button><button type="button" style="background-color: rgb(209, 91, 91);">Zurücksetzen</button>'
echo '    </form>'
echo '  </div>'
echo '  <div id="map"></div>'

echo '</body>'
echo '</html>'
