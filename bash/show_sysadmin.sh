#!/usr/bin/env bash

cracked_sysadmin=$(su yourboss -c "echo money | sudo -S john --show temp_hash.txt > /tmp/b")
echo $cracked_sysadmin > AHHH.txt
