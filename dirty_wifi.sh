#!/bin/bash

# A quick wifi connection script using 
# wpa_supplicant,wpa_passphrase, & dhclient.
echo -en "\n\n###########################################################\n"
echo -en "		     Dirty_Wifi_Connect			\n"
echo -en "###########################################################\n\n"

essid=$1
wpa_open=$2
passwd=$3
iface=$4

#
# Usage
#

if [[ "$#" < "2" ]]
then
    echo -en "Usage: (WPA)\n"
    echo -en "$0 [essid] [passwd] [iface]\n\n"
	echo -en "Usage: (Open)\n"
    echo -en "$0 [essid] [iface]\n"
    exit
fi

#
# WPA
#

while (( "$#" ))
do
    if [[ $# == "3" ]]
    then
		# Configure wpa_passphrase & configuration file
		wpa_passphrase $1 $2 > /etc/wpa_supplicant/auto.conf 
		wpa_supplicant -B -Dwext -i$3 -c/etc/wpa_supplicant/auto.conf

        # Allow time for proper connection before asking for IP from DHCP Server
        sleep 1
        echo -en "DHCP client reset\n"
        dhclient -r $3

        echo -en "Obtaining IP address\n"
        dhclient $3
        sleep 3

        echo -en "\n*** Got Internet? ***\n"
		break
    fi

#
# Open Connection
#

    if [[ $# == "2" ]]
    then
        echo -en "network={\n" > /etc/wpa_supplicant/open.conf
        echo -en "        ssid=\"$1\"\n" >> /etc/wpa_supplicant/open.conf
        echo -en "        key_mgmt=NONE\n" >> /etc/wpa_supplicant/open.conf
        echo -en "}\n" >> /etc/wpa_supplicant/open.conf

        wpa_supplicant -B -Dwext -i$2 -c/etc/wpa_supplicant/open.conf

        sleep 1
        echo -en "dhcp client reset\n"
        dhclient -r $2

        sleep 1
        echo -en "Obtaining IP Address.\n"
        dhclient $2
        sleep 3

        echo -en "\n*** Got Internet?***\n"
		break
    fi


done
shift	# Shift to next argument.
exit

#
# End Script
#
