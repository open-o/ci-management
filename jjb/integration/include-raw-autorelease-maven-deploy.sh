#!/bin/bash
# @License EPL-1.0 <http://spdx.org/licenses/EPL-1.0>
##############################################################################
# Copyright (c) 2015 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

# Assuming that mvn deploy created the hide/from/pom/files/stage directory.
cd hide/from/pom/files
mkdir -p m2repo/org/openo/

(IFS='
'
for m in `xmlstarlet sel -N x=http://maven.apache.org/POM/4.0.0 -t -m '//x:modules' -v '//x:module' ../../../../autorelease/pom.xml`; do
    rsync -avz --exclude 'maven-metadata*' \
               --exclude '_remote.repositories' \
               --exclude 'resolver-status.properties' \
               "stage/org/openo/$m" m2repo/org/openo/
done)

$MVN -V -B org.sonatype.plugins:nexus-staging-maven-plugin:1.6.2:deploy-staged-repository \
    -DrepositoryDirectory="`pwd`/m2repo" \
    -DnexusUrl=https://nexus.open-o.org/ \
    -DstagingProfileId="d8330dc636933" \
    -DserverId="openo.staging" \
    -s $SETTINGS_FILE \
    -gs $GLOBAL_SETTINGS_FILE | tee $WORKSPACE/deploy-staged-repository.log
