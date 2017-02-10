#!/bin/bash
$WORKSPACE/test/csit/docker/scripts/gen-all-dockerfiles.sh
$WORKSPACE/test/csit/docker/scripts/build-all-images.sh
$WORKSPACE/test/csit/docker/scripts/push-all-images.sh
