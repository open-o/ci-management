#!/bin/bash

# vim: ts=4 sw=4 sts=4 et tw=72 :

rh_systems() {
    # Install python dependencies
    yum install -y python-{devel,virtualenv,setuptools,pip}

    # Required to build some python package requirements
    yum install -y openssl-devel mysql-devel
}

ubuntu_systems() {
    # Install python dependencies
    apt install -y python-{dev,virtualenv,setuptools,pip}

    # Required to build some python package requirements
    apt install -y libssl-dev libmysqlclient-dev
}

all_systems() {
    echo 'No common distribution configuration to perform'
}

echo "---> Detecting OS"
ORIGIN=$(facter operatingsystem | tr A-Z a-z)

case "${ORIGIN}" in
    fedora|centos|redhat)
        echo "---> RH type system detected"
        rh_systems
    ;;
    ubuntu)
        echo "---> Ubuntu system detected"
        ubuntu_systems
    ;;
    *)
        echo "---> Unknown operating system"
    ;;
esac

# execute steps for all systems
all_systems
