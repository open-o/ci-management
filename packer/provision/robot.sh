#!/bin/bash

# vim: ts=4 sw=4 sts=4 et tw=72 :

rh_systems() {
    # Assumes that python is already installed by basebuild

    # Install dependencies for robotframework and robotframework-sshlibrary
    yum install -y -q yum-utils unzip sshuttle nc libffi-devel openssl-devel

    # Actual installation of robot is done from an integration JJB script
}

ubuntu_systems() {
    # Assumes that python is already installed by basebuild

    # Install dependencies for robotframework and robotframework-sshlibrary
    apt install -y unzip sshuttle netcat libffi-dev libssl-dev

    # Actual installation of robot is done from an integration JJB script
}

all_systems() {
    echo 'No common distribution configuration to perform'
}

echo "---> Detecting OS"
ORIGIN=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')

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
