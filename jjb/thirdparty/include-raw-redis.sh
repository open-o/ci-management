#!/bin/bash
# vim: sw=4 sts=4 ts=4 et tw=80 :

# force any errors to cause the script and job to end in failure
set -xeu -o pipefail

VERSION=3.2.6
PACKAGE=redis-${VERSION}.tar.gz

# Download Redis
wget "http://download.redis.io/releases/${PACKAGE}"
tar zxf "${PACKAGE}"
rm "${PACKAGE}"

cd "redis-${VERSION}/" || exit
make
# install bins locally
mkdir "${WORKSPACE}/install"
make PREFIX="${WORKSPACE}/install" install
cd "${WORKSPACE}/install"
tar czf "${WORKSPACE}/${PACKAGE}" bin

DISTRO=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')
case "${DISTRO}" in
    fedora|centos|redhat)
        OS_VERSION=$(facter operatingsystemmajrelease)
    ;;
    *)
        OS_VERSION=$(facter operatingsystemrelease | tr '.' '_')
    ;;
esac

${MVN} deploy:deploy-file -gs "${GLOBAL_SETTINGS_FILE}" -s "${SETTINGS_FILE}" \
    -Dfile="${WORKSPACE}/${PACKAGE}" -DrepositoryId=thirdparty \
    -Durl="${NEXUSPROXY}/content/repositories/thirdparty/" \
    -DgroupId="org.redis.${DISTRO}.${OS_VERSION}" \
    -Dversion="${VERSION}" -DartifactId=redis \
    -Dpackaging=tar.gz
