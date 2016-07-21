#!/bin/bash
# @License EPL-1.0 <http://spdx.org/licenses/EPL-1.0>
##############################################################################
# Copyright (c) 2016 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

case "$(facter operatingsystem)" in
  Ubuntu)
    apt-get update
    ;;
  *)
    # Do nothing on other distros for now
    ;;
esac

IPADDR=$(facter ipaddress)
HOSTNAME=$(facter hostname)
FQDN=$(facter fqdn)

echo "${IPADDR} ${HOSTNAME} ${FQDN}" >> /etc/hosts

#Increase limits
cat <<EOF > /etc/security/limits.d/jenkins.conf
jenkins         soft    nofile          16000
jenkins         hard    nofile          16000
EOF

cat <<EOSSH >> /etc/ssh/ssh_config
Host *
  ServerAliveInterval 60

# we don't want to do SSH host key checking on spin-up systems
Host 10.30.56.0/23
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOSSH

cat <<EOKNOWN >  /etc/ssh/ssh_known_hosts
[gerrit.zephyrproject.org]:29418,[199.19.213.246]:29418 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLhAICjKMqwNREHPZvs95Hlk8HfGt2VX3i5qUBJCyQ6unqmnlxy7xf1TDWCw6Tnq4jJH3/9SplNYONy5uwvLDtUoLrSG4kD6vvYUjgMB6pa/ECtefMnPkhCv09XOdfzWfku3O9GQRO8cpzoZZSV1NqIR2VVde1Xs2dbBXAwkLW8F0VFNOYs1ihApEAQWYf+hi3j+FcZP/9VnI7kg1XVJttfBJIlm05BjAkyQ+cSllgVAEi4iW1Q2KZ2iDwhdzTlwa+FpLnezFJtYR+v9449Fz2tMgBDl30p3A1bPvBwndxMsiddxjVRGuj2oTzAwkSYLS2hXT5pZOl7DOrSt3sTCKD
EOKNOWN

# vim: sw=2 ts=2 sts=2 et :
