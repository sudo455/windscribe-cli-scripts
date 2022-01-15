protonvpn-cli ks --on
question() {
    zenity --question --no-wrap --text "do you want to connect to the proton vpn servers?"
}
if [[ "$rmf" == "status.txt" ]] ; then
    rm status.txt
fi
if question ; then
    rmf=$(ls | grep status.txt)
    protonvpn-cli c -f >> status.txt
else
    rmf=$(ls | grep status.txt)
    protonvpn-cli ks --off >> status.txt
    protonvpn-cli d >> status.txt
fi
protonvpn-cli s >> status.txt
ct=$(cat status.txt)
zenity --warning --no-wrap --text "$ct"
rm status.txt