#!/bin/sh -e

REPO_DIR="$2"
BUILD_DIR="$1"
IMAGE_NAME="darkmagus/build-$BUILD_DIR"

cd $BUILD_DIR
docker build -t $IMAGE_NAME .

docker run \
  --rm \
  -e USERID=$(id -u $USER) \
  -e GROUPID=$(id -g $USER) \
  -v "$(pwd)/:/build" \
  -v "$REPO_DIR:/deb" \
  $IMAGE_NAME
