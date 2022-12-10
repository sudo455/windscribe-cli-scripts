#!/bin/bash
source settings.conf  # loads config settings

# see if windscribe is installed
if [ $(which windscribe | grep /usr/sbin/windscribe) != "/usr/sbin/windscribe" ]
then
    bash ./install_windscribe_and_login.sh
fi

#configure 
ec=0
if [[ [$firewall == "auto"] || [$firewall == "on"] || [$firewall == "off"] ]]
then
    echo "firewall configuration error"
    ec=1
else
    windscribe firewall $firewall
fi

if [[ [$lan_bypass == "on"] || [$lan_bypass == "off"] ]]
then
    echo "lan bypass configuration error"
    ec=2
else
    windscribe lanbypass $lan_bypass
fi

if [[ [$port == 443] || [$port == 80] || [$port == 53] || [$port == 123] || [$port == 1194] ]]
then
    echo "port configuration error"
    ec=3
else
    windscribe port $port
fi

if [[ [$protocol == "UDP"] || [$protocol == "STEALTH"] || [$protocol == "TCP"] ]]
then
    echo "protocol configuration error"
    ec=4
else
    windscribe protocol $protocol
fi

if [[ $ec != 0 ]]
then
    echo "exit code: ${ec}"
    exit $ec
fi

while true
do
    #code of menus
    if [[ $(windscribe status | grep DISCONNECTED) == "DISCONNECTED" ]]
    then
        echo "1. start windscribe"
    else 
        echo "2. stop Protonvpn"
        echo "3. reconnect"
        echo "st. status"
        echo "4. speedtest"
    fi
    echo "s. settings"
    echo "e. exit"
    read answer
    if [[ "$answer" == "1" ]]
    then
        windscribe connect
    elif [[ "$answer" == "2" ]]
    then
        windscribe disconnect
    elif [[ "$answer" == "3" ]]
    then
        windscribe disconnect
        sleep 5
        windscribe connect
    elif [[ "$answer" == "st" ]]
    then
        windscribe status
    elif [[ "$answer" == "4" ]]
    then
        windscribe speedtest     
    elif [[ "$answer" == "s" ]]
    then
        while true
        do
            echo "1. edit settings with nano"
            echo "2. edit settings with vim"
            echo "e. to exit"

            read answer 
            if [[ "$answer" == "1" ]]
            then
                nano -mtS settings.conf
            elif [[ "$answer" == "2" ]]
            then
                vim settings.conf
            elif [[ "$answer" == "e" ]]
            then
                break
            else
                echo "wrong input try again ..."
            fi
        done
    elif [[ "$answer" == "e" ]]
    then
        break
    else 
        echo "wrong input try again ..."
    fi
   echo "press enter to continue ..."
    read something
    clear
done

exit 0