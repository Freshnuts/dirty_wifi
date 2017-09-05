#!/bin/bash

# Look for WAP that doesn't use encryption key.
# Uses grep and iwlist.

if iwlist wlan0 scan | grep -C 5 'Encryption key:off'
then
    echo "Open Wifi found."
else [[ $? == 1 ]]
    echo 'No open wifi found.'
fi
exit
