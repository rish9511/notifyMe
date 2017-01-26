#!/bin/bash
: '
confDir=~/.config/notifyMe/
confFile=~/.config/notifyMe/user.ini
if [ -f $confFile ]; then
	echo file exists
fi
if [ -d $confDir ]; then
	echo directory exists
else
	cd ~/.config/
	mkdir notifyMe
	cd notifyMe
	touch user.ini
	echo directory does not exist
fi
for args
do
	echo $args
done


systemType="$(uname)"
linux="Linux"
if [ $systemType == "Linux" ]
then
	echo it is linux
elif [ $systemType == "Darwin"]
then
	echo it is darwin
fi
#eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";
#/usr/bin/notify-send "Upcoming Fixtures" "`curl -X POST http://localhost/resource/`"


storeUsersConfig() {
	#start processing the arguments
	for args:
	do
		echo asdas
	done
	
}
if [ $# -ne 0 ]
then
	storeUsersConfig
fi
'
# initialize the directory and files that will be needed
init() {
	if [ ! -f ~/.config/notifyMe/notifyMe.ini ]; then
		mkdir -p ~/.config/notifyMe
		touch ~/.config/notifyMe/notifyMe.ini
	fi
	systemType="$(uname)"
	if [ ${systemType,,} == "linux" ]; then
		eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";
		linux=1
	fi
	if [ ${systemType,,} == "darwin" ]; then
		darwin=1
	fi
}
		
#store the supported argumens in the ini file
#supported args= teamNameOfTheTeam (to receive notifications for a particular team) , upcoming(to receive notifications about upcoming
#fixtures of the day)

processArgs() {
	if [ $# -ne 0 ]
	then
		teamRe="^team(.*)"
		upComingRe="(upcoming)"
		file=~/.config/notifyMe/notifyMe.ini
		for args; do
			# convert to lower before matching
			if [[ ${args,,} =~ $teamRe ]]
			then
				grep   -qF "team=${BASH_REMATCH[1]}" "$file"  || echo team="${BASH_REMATCH[1]}" >> "$file"
			elif [[ ${args,,} =~ $upComingRe ]]
			then
				echo "upcoming=Yes" >> "$file"
			else
				echo $args not supported
			fi
		done
	fi
}

# get the user's configuration from the ini file
readIniFile() {
	if [ -f ~/.config/notifyMe/notifyMe.ini ]; then
		teamRe="^team=(.*)"
		upComingRe="^upcoming=(.*)"
		
		while read p; do
			if [[ ${p,,} =~ $teamRe ]]
			then
				sleep 20
				postToServer_favTeam ${BASH_REMATCH[1]}
			fi
			if [[ ${p,,} =~ $upComingRe ]]
			then
				postToServer_upcoming ${BASH_REMATCH[1]}
			fi
		done < ~/.config/notifyMe/notifyMe.ini
	
	else
		# should not happen
		echo the ini file does not exist
	fi

}
postToServer_favTeam() {
	
	if [ ! -z "$1" ]; then
		if [ $linux == 1 ]; then
			resp=`curl -X POST -d "$1" http://localhost/favTeam`
			if [ ! -z "$resp" ];then
				`notify-send "Upcoming fixture" "$resp"`
			else
				`notify-send  "No match of $1"`
			fi
			teamName=""
		fi
	fi
}

postToServer_upcoming() {

	echo upcoming
}

declare -i linux=0
declare -i darwin=0
declare -a userConf
init
processArgs $@
readIniFile

# get the user's configuration from the ini file

# post a request to the server with the details extracted from  the ini file

# display response using notification system


