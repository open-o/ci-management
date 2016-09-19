#!/bin/bash

# vim: ts=4 sw=4 sts=4 et tw=72 :

rh_systems() {
    # Install redis-server
    wget http://download.redis.io/releases/redis-3.2.3.tar.gz
    tar xzf redis-3.2.3.tar.gz
    cd redis-3.2.3
    make
    make install
    nohup /usr/local/bin/redis-server &
}

ubuntu_systems() {
    # Install redis-server
    apt install -y redis-server
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
