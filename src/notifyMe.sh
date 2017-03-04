#!/bin/bash
 
# initialize the directory and files that will be needed
init() {
    if [ ! -f ~/.config/notifyMe/notifyMe.ini ]; then
        mkdir -p ~/.config/notifyMe
        touch ~/.config/notifyMe/notifyMe.ini
    fi
    type="$(uname)"
    systemType="$(echo "$type" | tr '[:upper:]' '[:lower:]')"
    if [ $systemType == "linux" ]; then
        eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";
        linux=1
    fi
    if [ $systemType == "darwin" ]; then
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
            config="$(echo "$args" | tr '[:upper:]' '[:lower:]')"
            if [[ $config =~ $teamRe ]]
            then
                grep   -qF "team=${BASH_REMATCH[1]}" "$file"  || echo team="${BASH_REMATCH[1]}" >> "$file"
            elif [[ $config =~ $upComingRe ]]
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
            fileTxt="$(echo "$p" | tr '[:upper:]' '[:lower:]')"
            echo $fileTxt
            if [[ $fileTxt =~ $teamRe ]]
            then
                sleep 20
                postToServer_favTeam ${BASH_REMATCH[1]}
            fi
            if [[ $fileTxt =~ $upComingRe ]]
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
        resp=`curl -X POST -d "$1" http://ec2-52-89-23-95.us-west-2.compute.amazonaws.com/favTeam`
		if [ ! -z "$resp" ];then
            if [ $linux == 1 ]; then
                `notify-send "Upcoming fixture" "$resp" "--urgency=critical"`
            fi
            if [ $darwin == 1 ];then
                `osascript -e "display notification \"$resp\" with title \"Upcoming Fixture\" "`
               
            fi
        else
            if [ $linux == 1 ] ; then
                `notify-send "No match of $1"`
            fi
            if [ $darwin == 1 ]; then
                `osascript -e "display notification \"No match of $1\" with title \"Fixture update \" "`
            fi
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

