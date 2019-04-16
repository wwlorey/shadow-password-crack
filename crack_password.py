#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import crypt
import sys

pwd_entry = sys.argv[1].split('$')

salt = '$' + pwd_entry[1] + '$' + pwd_entry[2] + '$'
pwd_hash = pwd_entry[3][0:pwd_entry[3].find(':')]

with open('/usr/share/dict/american-english-small', 'r') as words:
	for line in words.read().split('\n'):
		if crypt.crypt(line, salt) == (salt + pwd_hash):
			print(line)
			break

