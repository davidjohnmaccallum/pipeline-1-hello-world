#!/bin/sh

# This script is executed by the build server. The build server sets the following
# environment variables: http://build.privyseal.com:8080/env-vars.html/.
#
# Author: david.maccallum@privyseal.com
# Date: 30 October 2017
#

DOCKER_REPO_NAME='pipeline-1-hello-world'
DOCKER_PATH='davidjohnmac'
echo
echo "Building $DOCKER_REPO_NAME:$BUILD_NUMBER"
echo "==========="
echo
echo "DOCKER_REPO_NAME: $DOCKER_REPO_NAME"
echo "BUILD_NUMBER: $BUILD_NUMBER"
echo "DOCKER_PATH: $DOCKER_PATH"
echo
echo "Building docker image and pushing to container registry"
(docker build -t "$DOCKER_REPO_NAME:$BUILD_NUMBER" . && \
  docker tag "$DOCKER_REPO_NAME:$BUILD_NUMBER" "${DOCKER_PATH}/${DOCKER_REPO_NAME}:$BUILD_NUMBER" && \
  docker tag "$DOCKER_REPO_NAME:$BUILD_NUMBER" "${DOCKER_PATH}/${DOCKER_REPO_NAME}:latest" && \
  docker push "${DOCKER_PATH}/${DOCKER_REPO_NAME}:$BUILD_NUMBER" && \
  docker push "${DOCKER_PATH}/${DOCKER_REPO_NAME}:latest") || exit $?
  echo
  echo "Tagging git repo with build number"
  git tag $BUILD_NUMBER
  git push --tags