#Main variables and environment
ZSH_THEME=mortalscumbag
CACHE=~/.cache
ScriptFolder=/usr/src
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.bash_profile
source ~/.oh-my-zsh/oh-my-zsh.sh

#Main script
## First we need to check if we're online to see if we can then keep going on receiving the weather
res=`ping google.com -c 1 -q -W 2 -w 2 | grep '1 packets transmitted, 1 received, 0% packet loss' | wc -l`
if [ "$res" -eq "1" ]
then
# We retrieve everything we need: we store it in weather.json
#First we check for the existence of the file	
$ScriptFolder/weather-v2.0.sh &>/dev/null

# We fetch the sunrise/set time
sunrise=$(cat $CACHE/weather.json |jq '.sys.sunrise')
sunset=$(cat $CACHE/weather.json|jq '.sys.sunset' )
#We need the minutes and hours as numeric values to keep going
sunriseMins=$(echo $sunrise | cut -c 5-6)
sunsetMins=$(echo $sunset | cut -c 5-6)
sunriseHours=$(echo $sunrise | cut -c 2-3)
sunsetHours=$(echo $sunset | cut -c 2-3)
sunriseMins=$(echo $sunriseMins|sed 's/^0*//')
sunsetMins=$(echo $sunsetMins|sed 's/^0*//')
#We need to parse them to the hour, that is the only thing we check
if [[ sunriseMins -ge 30 ]] #if the minutes are above half an hour, then we round it above
then
    sunriseHours=$(echo $sunriseHours|sed 's/^0*//')
    sunrise=$(($sunriseHours+1))
else #if the minutes are below 30, we just take the normal hour
    sunrise=$sunriseHours
fi

 # We do the same for the sunset time 
if [[ sunsetMins -ge 30 ]] #if the minutes are above half an hour, then we round it above
then
    sunsetHours=$(echo $sunsetHours|sed 's/^0*//')
    sunset=$(($sunsetHours+1))
else #if the minutes are below 30, we just take the normal hour
    sunset=$sunsetHours
fi
midday=$(($sunrise+($sunset-$sunrise)/2))
VAR=$(date +%H)


#Then we begin to print text with lolcat to have the beautiful colorful DNA strands
lolcat << 'END_DNA'
O       o O       o O       oO       o O       o O       o
| O   o | | O   o | | O   o || O   o | | O   o | | O   o |
| | O | | | | O | | | | O | || | O | | | | O | | | | O | |
| o   O | | o   O | | o   O || o   O | | o   O | | o   O |
o       O o       O o       Oo       O o       O o       O
END_DNA
echo -e "\n"

if [[ $VAR -ge $sunrise  ]] && [[ $VAR -le $(($midday-1)) ]]
then
	cat << 'END_MSG'
		* *           ▌ ▌   ▜               ▌        ▌
           *    *  *          ▌▖▌▞▀▖▐ ▞▀▖▞▀▖▛▚▀▖▞▀▖ ▛▀▖▝▀▖▞▀▖▌▗▘
      *  *    *     *  *      ▙▚▌▛▀ ▐ ▌ ▖▌ ▌▌▐ ▌▛▀  ▌ ▌▞▀▌▌ ▖▛▚ 
     *     *    *  *    *     ▘ ▘▝▀▘ ▘▝▀ ▝▀ ▘▝ ▘▝▀▘ ▀▀ ▝▀▘▝▀ ▘ ▘
 * *   *    *    *    *   *       
 *     *  *    * * .#  *   *	
 *   *     * #.  .# *   *       
  *     "#.  #: #" * *    *
 *   * * "#. ##"       *
   *       "###
             "##	                      
              ##.                   \  " '   ' "  /
              .##:                \    @@@@@@@@@     /
              :##:             \     @@@@@@@@@@@@@      /
              ;###                 @@@@@@@@@@@@@@@@@
            ,####.             " @@@@@@@@@@@@@@@@@@@@ " 
/\/\/\/\/\/.######.\/\/\/\/\/\/\@@@@@@@@@@@@@@@@@@@@@@/\/\/\/\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&&&&&&&&&&&&&&&&&&&&&&~~~~~~~~~~
END_MSG

elif [[ $VAR -ge $(($midday-1)) ]] && [[ $VAR -le $(($sunset-1)) ]]
then
	cat << 'END_MSG'
		* *    
           *    *  *
      *  *    *     *  *
     *     *    *  *    *             ;   :   ;
 * *   *    *    *    *   *        .   \_,!,_/   , 
 *     *  *    * * .#  *   *        `.,'     `.,'
 *   *     * #.  .# *   *            /         \
  *     "#.  #: #" * *    *     ~ -- :         : -- ~      
 *   * * "#. ##"       *             \         /
   *       "###                     ,'`._   _.'`.              
             "##                   '   / `!` \   `  
              ##.                     ;   :   ;
              .##:                 
              :##:            
              ;###              Welcome Back !
            ,####.           
/\/\/\/\/\/.######.\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
END_MSG

elif [[ $VAR -ge $(($sunset-1)) ]] && [[ $VAR -le $(($sunset+1)) ]]
then
	cat << 'END_MSG'
		* *    
           *    *  *
      *  *    *     *  *
     *     *    *  *    *
 * *   *    *    *    *   *       
 *     *  *    * * .#  *   *	  Welcome back !
 *   *     * #.  .# *   *       
  *     "#.  #: #" * *    *
 *   * * "#. ##"       *
   *       "###
             "##	                      
              ##.                   ~  " '   ' "  ~
              .##:                ~    @@@@@@@@@     ~
              :##:             ~    ~@@@@@@@@@@@@@~    ~
              ;###               ~~@@@@@@@@@@@@@@@@@~~
            ,####.             " @@@@@@@@@@@@@@@@@@@@ " 
/\/\/\/\/\/.######.\/\/\/\/\/\/\@@@@@@@@@@@@@@@@@@@@@@/\/\/\/\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&&&&&&&&&&&&&&&&&&&&&&~~~~~~~~~~
END_MSG


elif [[ $VAR -ge $(($sunset+1)) ]] || [[ $VAR -le $sunrise ]]
then
	cat << 'END_MSG'
		* *    
           *    *  *        *       _.-'''-._       *
      *  *    *     *  *          .'   .-'``|'.
     *     *    *  *    *        /    /    -*- \
 * *   *    *    *    *   *     ;   <{      |   ;
 *     *  *    * * .#  *        |    _\ |       | 
 *   *     * #.  .# *   *       ;   _\ -*- |    ;      *
  *     "#.  #: #" * *    *      \   \  | -*-  /
 *   * * "#. ##"       *          '._ '.__ |_.'
   *       "###                      '-----'
             "##	                        *
      *       ##.         *              
              .##:               *                      *
  *            :##:    *        
              ;###              Welcome Back !  *
            ,####.           
/\/\/\/\/\/.######.\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
END_MSG
fi

echo -e "\n"
echo -e "\r $USER, today is $(date +"%A, %d-%m-%y")"
toilet -f mono9 $(date +%H:%M)
echo -e "The weather today in $(cat $CACHE/weather.json | jq -r '.name' | sed "s|\<.|\U&|g") is : \n"
#smblock might be nice too
#toilet -f term "$(figlet -n -f term " Main temperature will be of: $(cat $CACHE/weather.json | jq '.main.temp' | awk '{print int($1+0.5)}')°C
#(min: $(cat $CACHE/weather.json | jq -r '.main.temp_min' | awk '{print int($1+0.5)}')°C ; max: $(cat $CACHE/weather.json | jq -r '.main.temp_max' | awk '{print int($1+0.5)}')°C)
#Humidity: $(cat $CACHE/weather.json | jq '.main.humidity')%
#Wind speed: $(cat $CACHE/weather.json | jq '.wind.speed')km/h")"
echo -e "\e[32mMain temperature will be of: $(cat $CACHE/weather.json | jq '.main.temp' | awk '{print int($1+0.5)}')°C\n
(min: $(cat $CACHE/weather.json | jq -r '.main.temp_min' | awk '{print int($1+0.5)}')°C max: $(cat $CACHE/weather.json | jq -r '.main.temp_max' | awk '{print int($1+0.5)}')°C) \n
Humidity: $(cat $CACHE/weather.json | jq '.main.humidity')% \n
Wind speed: $(cat $CACHE/weather.json | jq '.wind.speed')km/h \n" 


lolcat << 'END_DNA'
O       o O       o O       oO       o O       o O       o
| O   o | | O   o | | O   o || O   o | | O   o | | O   o |
| | O | | | | O | | | | O | || | O | | | | O | | | | O | |
| o   O | | o   O | | o   O || o   O | | o   O | | o   O |
o       O o       O o       Oo       O o       O o       O
END_DNA
else
echo -e "\n"
	cat << 'END_MSG'
		* *    
           *    *  *
      *  *    *     *  *
     *     *    *  *    *
 * *   *    *    *    *   *       
 *     *  *    * * .#  *   *	  Welcome back !
 *   *     * #.  .# *   *         Your computer is not connected to any network =(
  *     "#.  #: #" * *    *
 *   * * "#. ##"       *
   *       "###
             "##	                      
              ##.             
              .##:            
              :##:            
              ;###            
            ,####.            
/\/\/\/\/\/.######.\/\/\/\/\/\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
END_MSG
echo -e "\r $USER, today is $(date +"%A, %d-%m-%y")"
toilet -f mono12 $(date +%H:%M)


lolcat << 'END_DNA'
O       o O       o O       oO       o O       o O       o
| O   o | | O   o | | O   o || O   o | | O   o | | O   o |
| | O | | | | O | | | | O | || | O | | | | O | | | | O | |
| o   O | | o   O | | o   O || o   O | | o   O | | o   O |
o       O o       O o       Oo       O o       O o       O
END_DNA
fi
