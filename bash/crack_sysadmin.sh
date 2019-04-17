#!/usr/bin/env bash

# Crack sysadmin's password using john
 su yourboss -c "echo money | sudo -S john --wordlist=/usr/share/dict/american-english-small temp_hash.txt" > /tmp/a.txt
