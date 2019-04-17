#!/usr/bin/env python3

import sys

pwd_entry = sys.argv[1].split('$')

user = pwd_entry[0]
salt = '$' + pwd_entry[1] + '$' + pwd_entry[2] + '$'
pwd_hash = pwd_entry[3][0:pwd_entry[3].find(':')]

print(salt + pwd_hash)
