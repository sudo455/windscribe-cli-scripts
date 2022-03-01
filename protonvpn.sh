#Hello in this project i will try to create a protonvpn-cli script that has a deferent more
#user-frendly cli-gui

source settings.conf # loads config settings

####################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#|         error codes:            |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1: Can not start because the auto_configuration_at_start_of_this_scrip is not set to true
#      or false
#       Please check your settings.conf file and try again.
#
#   2: Can not configure the connection protocol TCP or UDP.
#       Please check your settings.conf file and try again.
#
#   3: Can not configure the dns. At least one dns is required for the program to run correctly
#       Please check your settings.conf file and try again.
#
#   4: Can not configure to use_dns or not. At least true or auto in the value use_dns is required for the program to run correctly
#       Please check your settings.conf file and try again.
#
#   5: Can not configure if the fast connection is enabled or disabled
#       Please check your settings.conf file and try again.
#
#   6: Can not configure if the vpn acceleration is enabled or disabled
#       Please check your settings.conf file and try again.
#
#   7: Can not configure if the vpn acceleration is enabled or disabled
#       Please check your settings.conf file and try again.
#
#   8:Can not configure if the kill switch is enabled or disabled
#       Please check your settings.conf file and try again.
#

if [[ $auto_configuration_at_start_of_this_scrip == true ]]; then
    if [[ $connection_protocol == "TCP" ]]; then
        echo ""
        echo "connection protocol: $connection_protocol"
        echo ""
        protonvpn-cli config -p tcp
    elif [[ $connection_protocol == "UDP" ]]; then
        echo ""
        echo "connection protocol: $connection_protocol"
        echo ""
        protonvpn-cli config -p udp
    else
        echo ""
        echo "error code:2"
        echo "Can not configure the connection protocol TCP or UDP"
        echo "Please check your settings file and try again."
        echo ""
        exit 2
    fi
    if [[ $use_dns == "true" ]]; then
        echo ""
        echo "dns option is: $dns1, $dns2, $dns3."
        echo ""
        if [[ $dns3 != N/A ]]; then
            protonvpn-cli config --dns custom --ip $dns1 $dns2 $dns3
        elif [[ $dns2 != N/A ]]; then
            protonvpn-cli config --dns custom --ip $dns1 $dns2
        elif [[ $dns1 != N/A ]]; then
            protonvpn-cli config --dns custom --ip $dns1
        elif [[ $dns1 == N/A ]]; then
            echo ""
            echo "error code: 3"
            echo "Can not configure the dns. At least one dns is required for the program to run correctly"
            echo "Please check your settings file and try again."
            echo ""
            exit 3
        fi
    elif [[ $use_dns == "auto" ]]; then
        echo ""
        echo "dns option is auto"
        echo ""
        protonvpn-cli config --dns automatic
    else
        echo ""
        echo "error code: 4"
        echo "Can not configure to use_dns or not. At least true or auto in the value use_dns is required for the program to run correctly"
        echo "Please check your settings file and try again."
        echo ""
        exit 4
    fi
    if [[ $fast_connection == true ]]; then
        echo ""
        echo "fast connection option is enabled"
        echo ""
        fast_connection_pr=" -f"
    elif [[ $fast_connection == false ]]; then
        echo ""
        echo "fast connection is disabled"
        echo ""
    else
        echo ""
        echo "error code: 5"
        echo "Can not configure if the fast connection is enabled or disabled"
        echo "Please check your settings file and try again."\
        echo ""
        exit 5
    fi
    if [[ $vpn_accelerator == true ]]; then
        echo ""
        echo "vpn acceleration option is enabled"
        echo ""
        protonvpn-cli config --vpn-accelerator enable
    elif [[ $vpn_accelerator == false ]]; then
        echo ""
        echo "vpn acceleration is disabled"
        echo ""
        protonvpn-cli config --vpn-accelerator disable
    else
        echo ""
        echo "error code: 6"
        echo "Can not configure if the vpn acceleration is enabled or disabled"
        echo "Please check your settings file and try again."
        echo ""
        exit 6
    fi
    if [[ $alt_routing == true ]]; then
        echo ""
        echo "vpn acceleration option is enabled"
        echo ""
        protonvpn-cli config --alt-routing enable
    elif [[ $alt_routing == false ]]; then
        echo ""
        echo "vpn acceleration is disabled"
        echo ""
        protonvpn-cli config --alt-routing disable
    else
        echo ""
        echo "error code: 7"
        echo "Can not configure if the vpn acceleration is enabled or disabled"
        echo "Please check your settings file and try again."
        echo ""
        exit 7
    fi
    if [[ $kill_switch == true ]]; then
        echo ""
        echo "kill switch is enabled"
        echo ""
        protonvpn-cli ks --on
    elif [[ $kill_switch == false ]]; then
        echo ""
        echo "kill switch is disabled"
        echo ""
        protonvpn-cli ks --off
    else
        echo ""
        echo "error code: 8"
        echo "Can not configure if the kill switch is enabled or disabled"
        echo "Please check your settings file and try again."
        echo ""
        exit 8
    fi
elif [[ $auto_configuration_at_start_of_this_scrip == false ]]; then
    echo ""
    echo "starting without configuration..."
    echo ""
else
    echo ""
    echo "error code:1"
    echo "can not start because the auto_configuration_at_start_of_this_scrip is not set to true"
    echo "or false"
    echo "Please check your settings file and try again."
    echo ""
    exit 1
fi
flag_continue=true
while $flag_continue == true; do

    if [[ $(protonvpn-cli s | grep No) == "No active ProtonVPN connection." ]]; then
        echo "1. Start Protonvpn"
    else
        echo "2. stop Protonvpn"
        echo "3. reconnect"
        echo "st. status"
    fi
    echo "s. settings"
    echo "e. exit"
    read answer
    if [[ "$answer" == "1" ]]; then
        protonvpn-cli c$fast_connection_pr
    elif [[ "$answer" == "2" ]]; then
        protonvpn-cli d
    elif [[ "$answer" == "3" ]]; then
        protonvpn-cli r
    elif [[ "$answer" == "st" ]]; then
        protonvpn-cli s
    elif [[ "$answer" == "s" ]]; then
        nano -mtS settings.conf
    elif [[ "$answer" == "e" ]]; then
        flag_continue=false
    else
        echo "wrong input."
        clear
    fi
done