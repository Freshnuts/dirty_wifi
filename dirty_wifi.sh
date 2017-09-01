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
if [[ "$#" < "3" ]]
then
	echo -en "usage:\n------\n"
    echo -en "dirty_wifi.sh [essid] [0:wpa|1:open] [passwd] [iface]\n\n"
    echo -en "** If open wifi, skip [passwd]\n"
    exit
fi

#
# WPA
#

while (( "$#" ))
do
    if [[ $2 == "0" ]]
	then
		# Configure wpa_passphrase & configuration file
		wpa_passphrase $1 $3 > /etc/wpa_supplicant/auto.conf 
		wpa_supplicant -B -Dwext -i$4 -c/etc/wpa_supplicant/auto.conf

    	# Allow time for proper connection before asking for IP from DHCP Server
    	sleep 1
    	echo -en "DHCP client reset\n"
    	dhclient -r $4

    	echo -en "Obtaining IP address\n"
    	dhclient $4
    	sleep 3

    	echo -en "\n*** Got Internet? ***\n"
		break
	else
		echo -en "\n Couldn't Connect. Error\n"
		break
	fi

#
# Open Connection
#
	if [[ $2 == "1" ]]
	then
    	echo -en "network={\n" > /etc/wpa_supplicant/open.conf
    	echo -en "        ssid=\"$1\"\n" >> /etc/wpa_supplicant/open.conf
    	echo -en "        key_mgmt=NONE\n" >> /etc/wpa_supplicant/open.conf
    	echo -en "}\n" >> /etc/wpa_supplicant/open.conf

    	wpa_supplicant -B -Dwext -i$4 -c/etc/wpa_supplicant/open.conf

    	sleep 1
    	echo -en "dhcp client reset\n"
    	dhclient -r $4

    	sleep 1
    	echo -en "Obtaining IP Address.\n"
    	dhclient $4
    	sleep 3

    	echo -en "\n*** Got Internet?***\n"
	else
    	echo -en "ERROR: Couldn't connect to wifi.\n"

	fi

# Shift to next argument.
shift
exit
#
# End Script
#
