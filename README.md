Note: viewing this document in the Gitlab interface is nice.

# Story
You suspect your boss is embezzling money, and you would really like to obtain your boss's password to gather evidence.
What you do with it is up to you...
Luckily, the sysadmin (who has a sudo account) at your company set the DAC permissions incorrectly on the default Linux password management files.
After learning this, you made friends with a temp worker (to frame him in the event of being found out), and came to an arrangement: 
if the temp will help you get the bosses password, you will write a program that does his job for him, so he can just surf Facebook and Tinder at work all day.
The temp worker does not know how to work "the PuTTY", and he cannot type very fast either, so you can't expect him to type out your commands at the bash terminal.
You can teach him enough to execute a single script via the terminal however.
You job is to write this script, which you can give to your "friend" the temp worker, that he can execute for you, that does the following: 
* processes the password files, 
* cracks the password for the account "yourboss" and "sysadmin"
  outputs the passwords (and only the passwords) to the screen,
* then fixes the permissions of the relevant password files to match the **Debian** defaults,
* clears the bash history,
* deletes any log or "dot" / config files created in the process of cracking the password,
* and finally, add the temp worker to the sudo'ers group (for future mischief).

The user tempworker gave you his password so you can include it in the script: "correctbatteryhorsestaple99" (why he has a reasonably good password is a mystery to you...).
You can't just use the password at any physical terminal though, since someone might notice you at the temp's computer, and you don't want evidence that you logged onto his account with your computer (that's just part of the story, not something you have to do...).
You may also discover that the system administrator's (sysadmin) password is also ironically weak.
Your internet research has discovered the following links about how to perform your task (not all of these will be critical, depending on which tools and methods you choose):

# Your internet research
Sudo and passwords
* http://www.yourownlinux.com/2015/08/etc-shadow-file-format-in-linux-explained.html
* https://www.debian.org/doc/manuals/debian-handbook/sect.user-group-databases.en.html
* https://wiki.debian.org/sudo
* https://unix.stackexchange.com/questions/86748/how-to-properly-configure-sudoers-file-on-debian-wheezy
* https://www.debian.org/doc/manuals/debian-reference/ch04.en.html#_managing_account_and_password_information
* https://www.linuxquestions.org/questions/linux-general-1/execute-command-as-different-user-63197/

Bash and sudo
* https://stackoverflow.com/questions/11955298/use-sudo-with-password-as-parameter
* https://superuser.com/questions/67765/sudo-with-password-in-one-command-line

Executing system bash commands in python (if you choose that route):
* https://docs.python.org/3.5/library/subprocess.html#subprocess.run

Bash scripting (if you choose that route, you should learn some basics scripting techniques)
* http://www.linuxcommand.org/lc3_learning_the_shell.php
* http://www.linuxcommand.org/lc3_writing_shell_scripts.php

John and Hashcat (for brute forcing)
* https://www.samsclass.info/123/proj10/p12-hashcat.htm
* https://www.blackmoreops.com/2015/11/10/cracking-password-in-kali-linux-using-john-the-ripper/

Wordlists already in Debian or Kali (for your dictionary inputs):
* /usr/share/wordlists/ (Kali)
* /usr/share/john/password.lst (Both)
* /usr/share/dict/ (Debian)

# Overview
0. Choose whether you want to write:
    * a bash script that occasionally calls a python script for the crypt lib operation (easier), or 
    * a python script that makes repeated bash commands, that may also need to call a bash script in a complicated way (harder).
1. Get the password of yourboss using a from-scratch script and nothing other than basic crypto tools (NOT jonh, hashcat, etc.) (65 pts)
2. Get sysadmin's password by using John or Hashcat (NOT the from-scratch method).
   Hint 1: these are in the repos, don't download them from some random website... (20 pts)
4. Give tempworker sudo ability (5 pts) - this is potentially much harder in python with nested bash. (maybe a little trick; read the links)
5. Then fix permissions on the shadow file (debian secure defaults) (5 pts) - this is potentially much harder in python with nested bash.
6. Clear your tracks, if you left any, like logfiles, history, etc. (5 pts)

# Setup
In a fresh install of your Debian or Kali VM (updated to latest software via apt-get), 
run this to setup the assignment:

```bash
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

# break permissions on shadow file
sudo chmod a+rwx /etc/shadow
```

# Hints
* Try all your commands at the regular bash command line first!
* You may need to make bash/system calls in python3; the best way to do this is subprocess.run
  I suggest you thoroughly read and understand subprocess.run, rather than just copy-pasting internet code...
* With bash as the main driver, occasionally calling python, it is easier (it's up to you).
* You will want to take and refresh VM snaphshots for testing your code repeatedly (IMPORTANT; don't test on a non-freshly broken VM).
* The sudo password for the tempworker must be typed automatically within your script;
  we will NOT provide any keyboard input during grading running (don't expect we will provide any).
* Please don't spam us with tons of console output.
* You do not have to delete your own script...
* Do NOT assume you will have internet access during runtime.
* Your script can call other scripts (even other bash or scripts in your repo perhaps).
* Make sure to include all your files in the repo.
* Do NOT just take the hashes from the script above and crack those -- you need to pull them from the shadow file.

# What to submit
* `funandgames.py` OR `funandgames.sh` (but not both)
* Screenshot of how you ran your script: `I_actually_tested_this.png` with LOWERCASE png :)
* Screenshot of the results produced by your script: `It_ran_on_my_machine.png` with LOWERCASE png :)

# Running
We will run your script as follows (in the home directory of a random new tempworker we have created without sudo permissions):

At the bash command line (not sh or zsh, bash):

Run as unprivileged tempworker (important; actually test this way, not as root!)

-- Refresh snapshot

`./code_to_break_vm_above.sh`

`$ whoami`

`tempworker`

`$ python3 funandgames.py`

`$ bash funandgames.sh`

Note: Putting a space before a command means it does not get entered into bash history, IF the environmental variable, $HISTCONTROL=ignoreboth, as it is in Debian.

# Password output:
* You can check your program output by doing this (which is how we will run it)

    `$ python3 funandgames.py >myout.txt  # Put space before command`

    `$ bash funandgames.sh >myout.txt  # Put space before command`

    `$ diff myout.txt example-output.txt`

* Make sure you don't have newline differences with this file.
* Make sure there are no differences (other than the passwords, which I can't give out).
* No output other than the system changes themselves should be produced for the other assignment components (like the permissions changes).

