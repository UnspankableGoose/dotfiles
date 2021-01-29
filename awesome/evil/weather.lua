-- Provide9s:
-- evil::weather
--      temperature (integer)
--      description (string)
--      icon_code (string)
local awful = require("awful")
local helpers = require("helpers")

-- Configuration
local key = user.openweathermap_key
local city_id = user.openweathermap_city_id
local units = user.weather_units
-- Don't update too often, because your requests might get blocked for 24 hours
local update_interval = 1200
local temp_file = "/tmp/awesomewm-evil-weather-"..city_id.."-"..units
local wind_temp_file = "/tmp/awesomewm-evil-wind-"..city_id.."-"..units

local weather_details_script = [[
    zsh -c '
    KEY="]]..key..[["
    CITY="]]..city_id..[["
    UNITS="]]..units..[["

    weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")

    if [ ! -z "$weather" ]; then
        weather_temp_min=$(echo "$weather" | jq ".main.temp_min" | cut -d "." -f 1)
        weather_temp_max=$(echo "$weather" | jq ".main.temp_max" | cut -d "." -f 1)
        weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
        weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)

        echo "$weather_icon" "$weather_description"@@"$weather_temp_min - $weather_temp_max"
    else
        echo "..."
    fi
  ']]

local wind_details_script = [[
    zsh -c '
    KEY="]]..key..[["
    CITY="]]..city_id..[["
    UNITS="]]..units..[["

    weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")

    if [ ! -z "$weather" ]; then
        weather_temp_min=$(echo "$weather" | jq ".wind.speed" | cut -d "." -f 1)
        weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
        weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)

        echo "$weather_icon" "$weather_description"@@"$weather_temp_min - $weather_temp_max"
    else
        echo "..."
    fi
  ']]

helpers.remote_watch(weather_details_script, update_interval, temp_file, function(stdout)
    local icon_code = string.sub(stdout, 1, 3)
    local weather_details = string.sub(stdout, 5)
    local wind_details = string.sub(stdout, 5)
    weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
    wind_details = string.gsub(wind_details, '^%s*(.-)%s*$', '$1')
    -- Replace "-0" with "0" degrees
    weather_details = string.gsub(weather_details, '%-0', '0')
    -- Capitalize first letter of the description
    weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)
    local description = weather_details:match('(.*)@@')
    local temperature = weather_details:match('@@(.*)')
    local wind = wind_details
    if icon_code == "..." then
        -- Remove temp_file to force an update the next time
        awful.spawn.with_shell("rm "..temp_file)
        awesome.emit_signal("evil::weather", 999, "Weather unavailable", "")
    else
        awesome.emit_signal("evil::weather", temperature, description, icon_code)
        --if tonumber(wind) < 10 then
        --    local wdescription = "Not very windy"
        --elseif tonumber(wind) > 10 and tonumber(wind) < 30 then
        --    local wdescription = "Kind of windy"
        --
        --elseif tonumber(wind) > 30 and tonumber(wind) < 50 then
        --    local wdescription = "Very windy"
        --
        --elseif tonumber(wind) > 50 and tonumber(wind) < 100 then
        --    local wdescription = "You better stay inside"
        --end
        
        --awesome.emit_signal("evil::weather", wind, wdescription, "💨")
    end
end)
