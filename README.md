# my zshrc file
## Description
This is the zshrc file I use for the moment.
I'll modify it through time because I might not like what it looks like for now. 
It uses geolocation to find when will be sunset and sunrise and then print a nice ascii art according to the time in the day. It also shows the the weather for the place you're in right now.
I adapted a few scripts I found from here and there so you might recognize things you've seen somewhere else. If I didn't quote you in the list please notify me and I'll add you ;)

![Screenshot from my terminal - I use kitty.](http://www.enlightenment.org/ss/e-65749a9c89d601.08580631.jpg)

### Future
In the future I'd like to add a mailutils wrapper that would show if I have unread mails. I might want to add a RSS feed also.

## Requirements
### Programs
You'll need to use :
- _curl_: to fetch infos on geolocation and weather,
- _toilet_: to write date in a nice format,
- _iwctl_: it's my network manager on systemd, I use it to get the ip adress,
- _zsh-autosuggestion_: it allows to do autocomplete in zsh, it's really nice,
- _oh-my-zsh_: plenty of different features, among them zsh theme management,
- _lolcat_: to generate nice looking DNA loops around my screen,
- _jq_: it allows to open json files directly from the shell.
### API and websites
To access the location, we call to [_tools.keycdn.com_](https://tools.keycdn.com), if you want to use another tool you can change that.
You'll need to make an account on [_openweathermap_](http://openweathermap.com) to have the api key you'll be able to use in the zshrc file.

## File description and what you might want to modify
### zshrc
The zshrc file where everything is stored.
You can modify the folders where everything is stored in by modifying the main variables on lines.
`$CACHE` : the **~/.cache/** file where the json files are stored by the _weather-v2.0.sh_ script.
`$ScriptFolder`: the **/usr/src/** folder where the weather-v2.0.sh script is stored.

### weather-v2.0.sh
The main script that allows to find location and weather.
`$CACHE` same as for zshrc. The must be similar to enable the two scripts to work together.

### bash_profile
The profile folder where all the aliases are stored.

## Credit
I need to give credit to [@closebox73](https://github.com/closebox73) that made most of the weather script.
