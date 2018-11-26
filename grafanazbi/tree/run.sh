#!/bin/bash
# This script is invoked as the default command to complete startup of the
# container after it has been templated.

service ssh start
# required: https://stackoverflow.com/a/43473861
sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron
service cron start

runsvdir /run/services &
PID=$!

cat /etc/sssd/sssd.conf*

trap "kill -TERM $PID" INT TERM
wait $PID
wait $PID
exit $?
