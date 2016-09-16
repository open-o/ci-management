#!/bin/bash

# This should be run from integration repo

ROOT=`git rev-parse --show-toplevel`/autorelease

BUILD_DIR=$ROOT/build

mkdir -p $BUILD_DIR
cd $BUILD_DIR

while read p; do
    rm -rf $BUILD_DIR/$p
    #TODO: replace with https once repo is open to public
    git clone ssh://openo-jobbuilder@gerrit.open-o.org:29418/$p
done < $ROOT/all-projects.txt

