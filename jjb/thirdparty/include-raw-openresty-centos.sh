#!/bin/bash
# vim: sw=4 sts=4 ts=4 et tw=80 :

# force any errors to cause the script and job to end in failure
set -xeu -o pipefail

#print glibc version
ldd --version

# Download openresty
PACKAGE=openresty-${VERSION}.tar.gz
wget "https://openresty.org/download/${PACKAGE}"
tar zxf "${PACKAGE}"
rm "${PACKAGE}"

# Download pcre
PCRE_PACKAGE=pcre-${PCRE_VERSION}.tar.gz
wget "https://ftp.pcre.org/pub/pcre/${PCRE_PACKAGE}"
tar zxf "${PCRE_PACKAGE}"
rm "${PCRE_PACKAGE}"

# Download zlib
ZLIB_PACKAGE=zlib-${ZLIB_VERSION}.tar.gz
wget "http://zlib.net/${ZLIB_PACKAGE}"
tar zxf "${ZLIB_PACKAGE}"
rm "${ZLIB_PACKAGE}"

# Download openssl
OPENSSL_PACKAGE=openssl-${OPENSSL_VERSION}.tar.gz
wget "https://www.openssl.org/source/${OPENSSL_PACKAGE}"
tar zxf "${OPENSSL_PACKAGE}"
rm "${OPENSSL_PACKAGE}"


# ldconfig needs to be on the path
export PATH=${PATH}:/sbin

cd "openresty-${VERSION}/" || exit
./configure -j2 \
--http-client-body-temp-path=temp/client_body_temp \
--http-proxy-temp-path=temp/proxy_temp \
--http-fastcgi-temp-path=temp/fastcgi_temp \
--http-scgi-temp-path=temp/scgi_temp \
--http-uwsgi-temp-path=temp/uwsgi_temp \
--with-select_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_stub_status_module \
--with-http_flv_module \
--with-http_ssl_module \
--with-stream \
--with-stream_ssl_module \
--with-pcre=../pcre-${PCRE_VERSION} \
--with-zlib=../zlib-${ZLIB_VERSION} \
--with-openssl=../openssl-${OPENSSL_VERSION}

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
