#!/bin/zsh

#Variables
CACHE=~/.cache
#We catch the ip from iwctl with this regex
ip=$(iwctl station wlan0 show| grep -oE '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))')
##Openweather api variables
# We will use the openweather api to check on the weather and sunset/sunrise time, you need an api key for this.
#############################################################################
api_key=   #Put your openweather api key here, you can obtain it for free ! #
#############################################################################
# choose between metric for Celcius or imperial for fahrenheit
unit=metric
# i'm not sure it will support all languange, 
lang=fr

#Functions
weatherUpdate(){
# If the file isn't up to date or doesn't exist we need to update it :
#We need to update the main file to have the following:
#wind speed in km/h
    #sunrise/sunset time in date format HH:MM
    #Updating Wind value
windval=$(bc -l <<<$(cat $CACHE/weather.json | jq '.wind.speed')*3.6)  #we want to put the wind speed in km/h : m/s->km/h we need to multiply the value by 3.6
    
echo $windval # we echo the windval to a temp file
tmp=$(mktemp)
jq --arg wind $windval '.wind.speed=($wind|tonumber|floor)' $CACHE/weather.json >> "$tmp" && mv "$tmp" $CACHE/weather.json #we update the file with the temp

#Sunrise value
sunriseval=$(date -d @$(cat $CACHE/weather.json | jq '.sys.sunrise') | cut -c 12-16) # we use the date command to evaluate the unix format retrieved from openweather map and write it as date format. 
echo $sunriseval
tmp=$(mktemp)
jq --arg sunrise $sunriseval '.sys.sunrise=($sunrise)' ~/.cache/weather.json >> "$tmp" && mv "$tmp" ~/.cache/weather.json

#Sunset value
sunseteval=$(date -d @$(cat ~/.cache/weather.json | jq '.sys.sunset') | cut -c 12-16) # we use the date command to evaluate the unix format retrieved from openweather map and write it as date format. 
echo $sunsetval
tmp1=$(mktemp)
jq --arg sunset $sunseteval '.sys.sunset=($sunset)' ~/.cache/weather.json >> "$tmp1" && mv "$tmp1" ~/.cache/weather.json

#Longitude value
echo $LONGITUDE
tmp2=$(mktemp)
jq --arg lon $LONGITUDE '.sys.longitude=($lon)' ~/.cache/weather.json >> "$tmp2" && mv "$tmp2" ~/.cache/weather.json

#Latitude value
echo $LATITUDE
tmp3=$(mktemp)
jq --arg lat $LATITUDE '.sys.latitude=($lat)' ~/.cache/weather.json >> "$tmp3" && mv "$tmp3" ~/.cache/weather.json
}


#Program begins here
if test -f $CACHE/location.json #First we check for the existence of the location file where the Long and Lat are stored
then # if the file exists we can retrieve everything directly
    Filedate=$(stat $CACHE/location.json --format="%y"  | cut -c 1-10) # We store the complete date to check
    Filehour=$(stat $CACHE/location.json --format="%y"  | cut -c 12-13) # We will want to check the hour also
    if [[ $Filedate!=$(date +"%Y-%m-%d") ]] # if the date is not the same we want to retrieve the file
    then
	curl -sH "User-Agent: keycdn-tools:https://github.com" https://tools.keycdn.com/geo.json\?host=$ip -o $CACHE/location.json
    elif [$Filedate=$(date +"%Y-%m-%d")] & [$(date +%H)!=$Filehour ] #if the date is the same but the time is different we update the file
    then
	curl -sH "User-Agent: keycdn-tools:https://github.com" https://tools.keycdn.com/geo.json\?host=$ip -o $CACHE/location.json
	fi
else # if the file doesn't exist we download it
    curl -sH "User-Agent: keycdn-tools:https://github.com" https://tools.keycdn.com/geo.json\?host=$ip -o $CACHE/location.json
fi
#We store the lon and lat in two variables
LATITUDE=$(cat $CACHE/location.json | jq '.data.geo.latitude')
LONGITUDE=$(cat $CACHE/location.json | jq '.data.geo.longitude')

# Main command
url="api.openweathermap.org/data/2.5/weather?lat=$LATITUDE&lon=$LONGITUDE&appid=${api_key}&cnt=5&units=${unit}&lang=${lang}"
# We check on the existence of the weather.json file the same way we did with location.json
if test -f $CACHE/weather.json
then    # if the file exists we need to check date/hour
    Filedate2=$(stat $CACHE/weather.json --format="%y"  | cut -c 1-10)
    Filehour2=$(stat $CACHE/weather.json --format="%y"  | cut -c 12-13)
    if [[ $Filedate2!=$(date +"%Y-%m-%d") ]] #We check the date. if it's different, we need to update the file
    then
	curl ${url} -s -o $CACHE/weather.json
	weatherUpdate #We then update the weather
    elif [ $Filedate2=$(date +"%Y-%m-%d")] & [$(date +%H)!=$Filehour2 ]
	then
	    curl ${url} -s -o $CACHE/weather.json
	    weatherUpdate #We then update the weather
    else #File exists for less than an hour, we don't have anything to do
	exit
    fi
else # if the file doesn't exist we download it and update windval
    curl ${url} -s -o $CACHE/weather.json
    weatherUpdate #We then need to update the weather
fi

exit

#We can safely exit the program



    
