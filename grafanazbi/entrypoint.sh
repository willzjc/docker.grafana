#!/bin/bash
: <<EOF
"${LDAP_BIND_USER_DN:?'is not defined'}"
"${LDAP_BIND_PASS:?'is not defined'}"
EOF

function clean_pid() {
	[ -z "$1" ] && { echo "ERROR: PID file not specified"; exit 1; }
	[ -f "$1" ] && rm -f "$1"
}

# Enforcing 1777 permissions on /tmp
chmod 1777 /tmp

service rsyslog start

/usr/sbin/authconfig --enablesssd --enablesssdauth --enablemkhomedir --enablepamaccess --update
# if the pid file exists messagebus won't start
clean_pid /var/run/messagebus.pid
# If messagebus service is not running, oddjobd will fail to start
service messagebus start && service oddjobd start

service sshd start

service ntpd start

clean_pid /var/run/sssd.pid
p2 -t /sssd.conf.p2 > /etc/sssd/sssd.conf
chmod 0600 /etc/sssd/sssd.conf
service nginx start
service sssd start
sleep infinity
