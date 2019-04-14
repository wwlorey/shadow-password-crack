#!/usr/bin/env bash

# This should be executed as root or sudo on your Kali or Debian VM, when internet is available.

# Installs the needed tools:
sudo apt install john hashcat wamerican*

# Creates sysadmin's account and password
sudo useradd sysadmin -m -p '$6$g0oUQt7l$Su1Nzm5XgOSnZqvECAqOhnxdHrGiuhqTRRaTEdAOw2jIQzLMx32Tluv3d5lfG7O5UAPM79LKnm4voFa2GJ36O0'
sudo usermod -a -G sudo sysadmin

# Creates yourboss's account and password
sudo useradd yourboss -m -p '$6$dbkKuKGS$XsniIqjOF39Kar2w3vZ8DuImkBihLJ0wR6skCAzwIFTDfbDdgQLYCyzRrcQeouT83didVrrOiXVYVARDpX88L/'
sudo usermod -a -G sudo yourboss

# Creates tempworker's account and password
sudo useradd tempworker -m -p '$6$g1VamdqE$RiEKGpb7gemh1Zt2JyVPq4Gzp/a2wTE5CPxNu97YaFfjS4wqbL2Nj1ousP2NWrUtjoVWw2nm8KdIcHzgzkw7R.'

# Your friend
sudo useradd yourbuddy -m -p '$6$tvsAYmsV$ieiv635zCbFpDMyYgjXtmwbBvgUlnrF246mnlpLcyPqZtP2fX0Dj6sbiVUrmEWJo.zOpokV8CV38RoUwo4Osx0'

# break permissions on shadow file
sudo chmod a+rwx /etc/shadow

