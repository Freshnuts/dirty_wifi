#!/bin/bash

# Look for WAP that does use encryption key.
# Uses iwlist and grep.

if iwlist wlan0 scan | grep -C 5 'Encryption key:on'
then
    echo 'Encryption enabled.'
else [[ $? == 1 ]]
    echo 'No wifi with Encryption found.'
fi
exit
