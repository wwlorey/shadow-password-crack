#!/usr/bin/env bash

# Parse the shadow password file
while IFS= read -r line; do
	if [ "${line:0:8}" = "sysadmin" ]; then
		sysadmin_hash=$line
	elif [ "${line:0:8}" = "yourboss" ]; then 
		yourboss_hash=$line
	elif [ "${line:0:9}" = "yourbuddy" ]; then
		yourbuddy_hash=$line
	fi
done < /etc/shadow

# Crack some passwords
 ./crack_password.py "$sysadmin_hash" > temp.txt
sysadmin_cracked=$(<temp.txt)
 ./crack_password.py "$yourboss_hash" > temp.txt
yourboss_cracked=$(<temp.txt)
 ./crack_password.py "$yourbuddy_hash" > temp.txt
yourbuddy_cracked=$(<temp.txt)

# Cleanup 
 rm temp.txt

# Testing
 echo $sysadmin_cracked
 echo $yourboss_cracked
 echo $yourbuddy_cracked

