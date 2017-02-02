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

# Explicitly list allowed top level subdirectories under org/openo/
rsync -av \
    --exclude 'maven-metadata*' \
    --exclude '_remote.repositories' \
    --exclude 'resolver-status.properties' \
    stage/org/openo/{client,common-services,common-tosca,gso,integration,nfvo,oparent,sdnhub,sdno,vnf-sdk} m2repo/org/openo/

# Check for invalid SNAPSHOT artifacts
INVALID_VERSIONS=`find m2repo/org/openo -name "*SNAPSHOT*"`
if [ ! -z "$INVALID_VERSIONS" ]
then
    echo "Error: found invalid SNAPSHOT artifacts"
    echo $INVALID_VERSIONS | tr ' ' '\n'
    exit 1
fi

$MVN -q -V -B org.sonatype.plugins:nexus-staging-maven-plugin:1.6.2:deploy-staged-repository \
    -DrepositoryDirectory="`pwd`/m2repo" \
    -DnexusUrl=https://nexus.open-o.org/ \
    -DstagingProfileId="d8330dc636933" \
    -DserverId="openo.staging" \
    -s $SETTINGS_FILE \
    -gs $GLOBAL_SETTINGS_FILE | tee $WORKSPACE/deploy-staged-repository.log
