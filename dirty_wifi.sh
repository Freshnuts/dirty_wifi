#!/bin/bash

# Connect to wifi using wpa_supplicant,wpa_passphrase, & dhclient.
# This script is doing the dirty work.
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
if [[ "$#" < "4" ]]
then
	echo -en "usage:\n------\n"
    echo -en "dirty_wifi.sh [essid] [0:wpa|1:open] [passwd] [iface]\n\n"
    echo -en "** If open wifi, type in passwd: open\n"
    exit
fi

#
# WPA
#
if [[ $2 == "0" ]]
then
    # Configure wpa_passphrase & configuration file
    wpa_passphrase $1 $3 > /etc/wpa_supplicant/auto.conf 
    wpa_supplicant -B -Dwext -i$4 -c/etc/wpa_supplicant/auto.conf

    # Allow time for proper connection before asking for IP from DHCP Server.
    sleep 1
    echo -en "DHCP client reset\n"
    dhclient -r

    echo -en "Obtaining IP address\n"
    dhclient $4
    sleep 3

    echo -en "\n*** Got Internet? ***\n"

#
# Open Connection
#
elif [[ $2 == "1" ]]
then
    echo -en "network={\n" > /etc/wpa_supplicant/open.conf
    echo -en "        ssid=\"$1\"\n" >> /etc/wpa_supplicant/open.conf
    echo -en "        key_mgmt=NONE\n" >> /etc/wpa_supplicant/open.conf
    echo -en "}\n" >> /etc/wpa_supplicant/open.conf

    wpa_supplicant -B -Dwext -i$4 -c/etc/wpa_supplicant/open.conf

    sleep 1
    echo -en "dhcp client reset\n"
    dhclient -r

    sleep 1
    echo -en "Obtaining IP Address.\n"
    dhclient $4
    sleep 3

    echo -en "\n*** Got Internet?***\n"
else
    echo -en "ERROR: Couldn't connect to wifi.\n"

fi

#
# End Script
#
