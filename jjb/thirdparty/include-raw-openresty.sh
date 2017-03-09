#!/bin/bash
# vim: sw=4 sts=4 ts=4 et tw=80 :

# force any errors to cause the script and job to end in failure
set -xeu -o pipefail

PACKAGE=openresty-${VERSION}.tar.gz

# Download openresty
wget "https://openresty.org/download/${PACKAGE}"
tar zxf "${PACKAGE}"

rm "${PACKAGE}"

# ldconfig needs to be on the path
export PATH=${PATH}:/sbin

cd "openresty-${VERSION}/" || exit
./configure -j2 \
    --with-pcre-jit \
    --with-ipv6

make -j2

mkdir "${WORKSPACE}/install"

make install DESTDIR="${WORKSPACE}/install"

cd "${WORKSPACE}/install/usr/local"

mv openresty "openresty-${VERSION}"

tar czf "${WORKSPACE}/${PACKAGE}" "openresty-${VERSION}"

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
    -DgroupId="org.openresty.${DISTRO}.${OS_VERSION}" \
    -Dversion="${VERSION}" -DartifactId=openresty \
    -Dpackaging=tar.gz
