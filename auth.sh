#!/usr/bin/expect
#!/usr/bin/env bash
set script [lindex $argv 0]
set password [lindex $argv 1]
spawn ./$script
expect "assword:"
send -- $password
