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
Host 10.30.96.* 10.30.97.*
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOSSH

cat <<EOKNOWN >  /etc/ssh/ssh_known_hosts
[gerrit.open-o.org]:29418,[198.145.29.91]:29418 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC63lHCxVeE/SwExgfi6EsncRtwpVOLUV0CJIlwgLasaJRk5mi4WB7r7Nltn+eC2loaYqEoboxf6vzcLIrvq2ODp+k3ZnI4Lc4Dtcw9RGLoLSCqxatagWBzw0/9pI/MqZB3bzGb03ItSCaUjYJJraoNe81hviG9hIvGUkTolB2oRMcZvpYNvpKlQ6xpD5lMAWQL82GWqTNoCg/LCn3oDu4fXV7IF3ZcJsglx2EiWHwjnLpmv/yNA9AIaFs+JkuBrSPhiKWetk208KxQQ9M/aACj6zcBNSAYZePMLpciMnnth4MMVTtgnABXouqX8e4TDDq9t4LufVSHmXTY+quIWBX3
EOKNOWN

# vim: sw=2 ts=2 sts=2 et :
