#error code 1 is for the port which is not UDP or TCP!
#error code 2 is for the dns which is not ex.: dns:auto or dns:1.1.1.1 , 1.0.0.1
flag=true

if [[ "$(grep -o "auto_configuration_at_start_of_this_scrip: " settings)" == "auto_configuration_at_start_of_this_scrip:yes" ]] ; then
    flagconf=false
else
    flagconf=true
fi

if [[ "$(protonvpn-cli s | grep "No active ProtonVPN connection.")" == "NO active ProtonVPN connection." ]] ; then
    flagconn=false
else
    flagconn=true
fi

while [[ $flag == true ]] ; do
    if [[ $flagconf == false ]] ; then

        echo ""
        echo "configuring..."
        k="$(cat settings | grep connectionprotocol: )"
        if [[ $k == "connectionprotocol:TCP" ]] ; then
            protonvpn-cli config -p tcp
        elif [[ $k == "connectionprotocol:UDP" ]] ; then
            protonvpn-cli config -p udp
        else
            echo "can't continue config error code:1"
            exit 1
        fi

        flagconfip=false
        ip=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' settings)
        if [[ $ip != "" ]] ; then
            protonvpn-cli config --dns custom --ip $ip
        else
            ip=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} , [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' settings)
            if [[ $ip != "" ]] ; then
                protonvpn-cli config --dns custom --ip $ip
            else
                ip=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} , [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\} , [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' settings)
                if [[ $ip != "" ]] ; then
                    protonvpn-cli config --dns custom --ip $ip
                else
                    if [[ "$(cat settings | grep dns:auto )" == "dns:auto" ]] ; then
                        protonvpn-cli config --dns automatic
                    else
                        echo "can't config exit code 2!"
                        exit 1
                    fi
                fi
            fi
        fi
        
        echo " "
        echo "done configuring"
        echo " "
        flagconf=true
    fi
    flag1=true
    flag2=false
    while [[ $flag1 == true ]] ; do
        if [[ $flag2 == true ]] ; then
            clear
        fi
        echo "menu"
        echo "1-start proton vpn"
        if [[ $flagconn == true ]] ; then    
            echo "2-stop proton vpn"
            echo "3-reconnect proton vpn"
        fi
        echo "st-status proton vpn"
        echo "s-settings"
        echo "e-exit"
        read ans
        if [[ $ans == 1 ]] ; then
            flag1=false
            flagconn=true
            flag2=true
        elif [[ $ans == 2 ]] ; then
            flag1=false
            flagconn=false
            flag2=true
        elif [[ $ans == 3 ]] ; then
            flag1=false
            flagconn=false
            flag2=true
        elif [[ $ans == st ]] ; then
            flag1=false
        elif [[ $ans == s ]] ; then
            flag1=false
            flag2=true
        elif [[ $ans == e ]] ; then
            flag1=false
            flag2=true
        fi
    done
    if [[ $ans == 1 ]] ; then
        k="$(cat settings | grep killswitch)"
        ks="killswitch:on"
        if [[ $k == $ks ]] ; then
            protonvpn-cli ks --on && protonvpn-cli c -f
        else
            protonvpn-cli c -f
        fi
    elif [[ $ans == 2 ]] ; then
        k="$(cat settings | grep killswitch)"
        ks="killswitch on"
        if [[ $k == $ks ]] ; then
            protonvpn-cli ks --off && protonvpn-cli d
        else
            protonvpn-cli d
        fi
    elif [[ $ans == 3 ]] ; then
        protonvpn-cli r
    elif [[ $ans == st ]] ; then
        clear
        protonvpn-cli s
    elif [[ $ans == s ]] ; then
        flags=true
        while [[ $flags == true ]] ; do
            clear
            echo "menu2"
            echo "1 or edwnano-edit the settings text file via nano"
            echo "2 or edwnote-edit the settings text file via notepadqq"
            echo "3 or edwgedi-edit the settings text file via gedit"
            echo "e-exit"
            read anss
            if [[ $anss == edwnano ]] ; then
                nano -mt settings
                flags=false
            elif [[ $anss == edwnote ]] ; then
                notepadqq settings
                flags=false
            elif [[ $anss == edwgedi ]] ; then
                gedit settings
                flags=false
            elif [[ $anss == 1 ]] ; then
                nano -mt settings
                flags=false
            elif [[ $anss == 2 ]] ; then
                notepadqq settings
                flags=false
            elif [[ $anss == 3 ]] ; then
                gedit settings
                flags=false
            elif [[ $anss == e ]] ; then
                flags=false
            elif [[ $anss == ee ]] ; then
                flag=false
                flags=false
            fi
        done
    elif [[ $ans == e ]] ; then
        flag=false
    fi
done