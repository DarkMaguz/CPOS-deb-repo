#!/bin/sh -e

docker build -t darkmagus/build-firefox-deb .

docker run \
  --rm \
  -e USERID=$(id -u $USER) \
  -e GROUPID=$(id -g $USER) \
  -v ./:/build \
  darkmagus/build-firefox-deb
